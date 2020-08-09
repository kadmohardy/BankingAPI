defmodule StoneChallenge.BackOffice do
  @moduledoc """
  This module handle Accounts context
  """
  import Ecto.Query, warn: false

  require Logger
  alias StoneChallenge.Repo
  alias StoneChallenge.Banking
  alias StoneChallenge.Banking.Transaction

  def transactions_report(params) do
    type = Map.get(params, "type")

    cond do
      type == "diary" ->
        date = Map.get(params, "date")
        diary_transactions_report(date)

      type == "monthly" ->
        month = Map.get(params, "month")
        monthly_transactions_report(month)

      type == "yearly" ->
        year = Map.get(params, "year")
        yearly_transactions_report(year)

      type == "total" ->
        total_transactions_report()
    end

    Logger.info("TYPE ============= #{inspect(params)}")
  end

  defp diary_transactions_report(date) do
    total = row_counts_by_date("2020-08-05") |> Repo.all() |> Map.new()

    Logger.info("TYPE ============= #{inspect(total)}")
  end

  defp monthly_transactions_report(month) do
    # Logger.info("TYPE ============= DATA DE TESTE#{inspect(teste)}")
  end

  defp yearly_transactions_report(year) do
    # row_counts_by_date() |> Repo.all() |> Map.new()
  end

  defp total_transactions_report() do
    Repo.all(from t in Transaction, select: sum(t.amount))
  end

  @doc "to_char function for formatting datetime as dd MON YYYY"
  defmacro to_char(field, format) do
    quote do
      fragment("to_char(?, ?)", unquote(field), unquote(format))
    end
  end

  @doc "Builds a query with row counts per inserted_at date"
  def row_counts_by_date(date) do
    from record in Transaction,
      group_by: to_char(record.inserted_at, ^date),
      select: {to_char(record.inserted_at, ^date), sum(record.amount)}
  end
end

# defmodule CountByDateQuery do
#   import Ecto.Query

#   @doc "to_char function for formatting datetime as dd MON YYYY"
#   defmacro to_char(field, format) do
#     quote do
#       fragment("to_char(?, ?)", unquote(field), unquote(format))
#     end
#   end

#   @doc "Builds a query with row counts per inserted_at date"
#   def row_counts_by_date do
#     from record in SomeTable,
#     group_by: to_char(record.inserted_at, "dd Mon YYYY"),
#     select: {to_char(record.inserted_at, "dd Mon YYYY"), count(record.id)}
#   end

# end
