defmodule StoneChallengeWeb.ReportsViewTest do
  use StoneChallengeWeb.ConnCase, async: true
  import Phoenix.View
  require Logger

  test "renders show.json", %{conn: conn} do
    total = 75.50

    rendered_report = render(
      StoneChallengeWeb.ReportsView,
      "show.json",
      conn: conn,
      total: total)

    assert rendered_report.data === total
  end
end
