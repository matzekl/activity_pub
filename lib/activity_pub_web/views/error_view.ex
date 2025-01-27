defmodule ActivityPubWeb.ErrorView do
  @moduledoc """
  Standard error view
  """
  use ActivityPubWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.html", _assigns) do
    "Internal Server Error - ActivityPub"
  end

  def render("404.json", _assigns) do
    "Not Found - ActivityPub"
  end

  def render("500.json", _assigns) do
    "Internal Server Error - ActivityPub"
  end

  @doc """
    By default, Phoenix returns the status message from the template name. For example, "404.html" becomes "Not Found".
  """
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
