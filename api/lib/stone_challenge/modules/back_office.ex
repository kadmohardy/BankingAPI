defmodule StoneChallenge.BackOffice do
  @moduledoc """
  This module handle Back Office context
  """
  import Ecto.Query, warn: false

  require Logger
  alias StoneChallenge.Repo
  alias StoneChallenge.Helper.StringsHelper
  alias StoneChallenge.Banking.Transaction

  def transactions_report(params) do
    day = Map.get(params, "day")
    month = Map.get(params, "month")
    year = Map.get(params, "year")

    case is_valid_numbers_params(day, month, year) do
      {:ok, _} ->
        {:ok, report_type} = get_report_type(day, month, year)

        Logger.info("REPORT TYPE #{inspect(report_type)}")

        cond do
          report_type == "diary" ->
            generate_diary_report(day, month, year)

          report_type == "monthly" ->
            generate_monthly_report(month, year)

          report_type == "yearly" ->
            generate_yearly_report(year)

          true ->
            total_transactions_report()
        end

      {:error, message} ->
        {:error, message}
    end
  end

  defp diary_transactions_report(day, month, year) do
    Logger.info("RESULT DATA }")
    period = StringsHelper.format_day_month_and_year(day, month, year)

    row_counts_by_day(period) |> Repo.all() |> Map.new()
  end

  defp monthly_transactions_report(month, year) do
    period = StringsHelper.format_month_and_year(month, year)
    row_counts_by_month(period) |> Repo.all() |> Map.new()
  end

  defp yearly_transactions_report(year) do
    row_counts_by_year(year) |> Repo.all() |> Map.new()
  end

  defp total_transactions_report() do
    Repo.all(from t in Transaction, select: sum(t.amount))
  end

  defmacro to_char(field, format) do
    quote do
      fragment("to_char(?, ?)", unquote(field), unquote(format))
    end
  end

  defp row_counts_by_day(period) do
    from record in Transaction,
      group_by: to_char(record.inserted_at, "dd-mm-YYYY"),
      where:
        to_char(record.inserted_at, "dd-mm-YYYY") ==
          ^period,
      select: {"total", sum(record.amount)}
  end

  defp row_counts_by_month(period) do
    from record in Transaction,
      group_by: to_char(record.inserted_at, "mm-YYYY"),
      where: to_char(record.inserted_at, "mm-YYYY") == ^period,
      select: {"total", sum(record.amount)}
  end

  defp row_counts_by_year(period) do
    from record in Transaction,
      group_by: to_char(record.inserted_at, "YYYY"),
      where: to_char(record.inserted_at, "YYYY") == ^period,
      select: {"total", sum(record.amount)}
  end

  defp generate_diary_report(day, month, year) do
    n_day = String.to_integer(day)
    n_month = String.to_integer(month)
    n_year = String.to_integer(year)

    case validate_diary_report_params(n_day, n_month, n_year) do
      {:ok, _} -> {:ok, diary_transactions_report(day, month, year)}
      {:error, message} -> {:error, message}
    end
  end

  defp generate_monthly_report(month, year) do
    Logger.info("TESTANDO A A CRIACAO DO REPORT 2 MONTHLY")
    n_month = String.to_integer(month)
    n_year = String.to_integer(year)

    case validate_monthly_report_params(n_month, n_year) do
      {:ok, _} -> {:ok, monthly_transactions_report(month, year)}
      {:error, message} -> {:error, message}
    end
  end

  defp generate_yearly_report(year) do
    Logger.info("TESTANDO A A CRIACAO DO REPORT 3 YEARLY")
    n_year = String.to_integer(year)

    case validate_yearly_report_params(n_year) do
      {:ok, _} -> {:ok, yearly_transactions_report(year)}
      {:error, message} -> {:error, message}
    end
  end

  defp validate_diary_report_params(day, month, year) do
    Logger.info("TESTANDO DAY 3 YEARLY #{inspect(day)}")

    cond do
      day <= 0 || day > 31 ->
        {:error, "Provide a valid day (a number between 1 and 31)"}

      month < 1 || month > 12 ->
        {:error, "Provide a valid month (a number between 1 and 12)"}

      year <= 0 ->
        {:error, "Provide a valid year"}

      true ->
        {:ok, :success}
    end
  end

  defp validate_monthly_report_params(month, year) do
    cond do
      month <= 1 || month > 12 ->
        {:error, "Provide a valid month (a number between 1 and 12)"}

      year <= 0 ->
        {:error, "Provide a valid year"}

      true ->
        {:ok, :success}
    end
  end

  defp validate_yearly_report_params(year) do
    if year <= 0 do
      {:error, "Provide a valid year"}
    else
      {:ok, :success}
    end
  end

  defp get_report_type(day, month, year) do
    cond do
      day != nil && month != nil && year != nil ->
        {:ok, "diary"}

      month != nil && year != nil ->
        {:ok, "monthly"}

      year != nil ->
        {:ok, "yearly"}

      true ->
        {:ok, "total"}
    end
  end

  defp is_valid_numbers_params(day, month, year) do
    cond do
      !is_only_numbers(day) -> {:error, "Invalid day param"}
      !is_only_numbers(month) -> {:error, "Invalid month param"}
      !is_only_numbers(year) -> {:error, "Invalid year param"}
      true -> {:ok, :success}
    end
  end

  defp is_only_numbers(value) do
    Regex.match?(~r{\A\d*\z}, value)
  end
end
