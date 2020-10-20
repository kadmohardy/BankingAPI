defmodule StoneChallenge.Helper.StringsHelper do
  @moduledoc """
  This module describe auxiliar functions used to generate date strings
  """
  def format_day_month_and_year(day, month, year) do
    day <> "-" <> month <> "-" <> year
  end

  def format_month_and_year(month, year) do
    month <> "-" <> year
  end
end
