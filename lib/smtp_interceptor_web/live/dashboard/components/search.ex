defmodule SmtpInterceptorWeb.MailDashboard.Search do
  use SmtpInterceptorWeb, :html

  attr :title, :string, default: "Search"
  attr :form, Phoenix.HTML.Form
  def search_input(assigns) do
    ~H"""
      <div class="flex flex-col mt-5">
        <p class="flex items-center"><%= @title%></p>
        <.form class="flex items-baseline" for={@form} phx-submit="search">
          <.input type="text" field={@form[:search]}/>
          <.button class="bg-red-500 ml-4" type="submit">Buscar</.button>
        </.form>
    </div>
    """
  end
end
