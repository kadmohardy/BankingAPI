defmodule StoneChallenge.Helper.StringsHelper do
  @moduledoc """
  This module describe auxiliar functions used to generate date strings
  """
  require Logger
  @float_regex ~r/^(?<int>\d+)(\.(?<dec>\d+))?$/

  def format_day_month_and_year(day, month, year) do
    day <> "-" <> month <> "-" <> year
  end

  def format_month_and_year(month, year) do
    month <> "-" <> year
  end

  def parse_float(str) do
    result = Regex.named_captures(@float_regex, str)

    if result != nil do
      %{"int" => int_str, "dec" => decimal_str} = result
      decimal_length = String.length(decimal_str)

      if decimal_length != 2 do
        nil
      else
        {value, _} = Float.parse(str)
        Decimal.from_float(value)
      end
    else
      nil
    end
  end
end
