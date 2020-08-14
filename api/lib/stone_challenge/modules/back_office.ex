defmodule StoneChallenge.BackOffice do
  @moduledoc """
  This module handle Back Office context
  """
  import Ecto.Query, warn: false

  require Logger
  alias StoneChallenge.Repo
  alias StoneChallenge.Helper.StringsHelper
  alias StoneChallenge.Banking.Transaction

  def transactions_report(conn, params) do
    type = Map.get(params, "type")

    is_customer = conn.assigns.signed_user.customer

    cond do
      is_customer == true ->
        {:error, :user_not_authorized}

      type == "diary" ->
        year = Map.get(params, "year")
        month = Map.get(params, "month")
        day = Map.get(params, "day")
        {:ok, diary_transactions_report(day, month, year)}

      type == "monthly" ->
        month = Map.get(params, "month")
        year = Map.get(params, "year")
        {:ok, monthly_transactions_report(month, year)}

      type == "yearly" ->
        year = Map.get(params, "year")
        {:ok, yearly_transactions_report(year)}

      type == "total" ->
        {:ok, total_transactions_report()}
    end
  end

  defp diary_transactions_report(day, month, year) do
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
end
