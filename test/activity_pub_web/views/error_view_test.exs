defmodule ActivityPubWeb.ErrorViewTest do
  use ActivityPubWeb.ConnCase, async: false

  # Bring render/3 and render_to_string/3 for testing custom views
  # import Phoenix.View

  test "renders 404.json" do
    assert ActivityPubWeb.ErrorView.render("404.json", []) =~ "Not Found"
  end

  test "renders 500.json" do
    assert ActivityPubWeb.ErrorView.render("500.json", []) =~
             "Internal Server Error"
  end
end
