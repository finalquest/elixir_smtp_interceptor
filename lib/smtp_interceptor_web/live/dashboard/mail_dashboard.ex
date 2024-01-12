defmodule SmtpInterceptorWeb.MailDashboard do
  use SmtpInterceptorWeb, :live_view

  import SmtpInterceptorWeb.MailDashboard.Search

  def mount(_params, _session, socket) do
    {:ok, 
      assign(socket, brightness: 10, 
                form: to_form(%{"search"=>""})
                ), 
      layout: false
    }
  end
  
  # render
  def render(assigns) do
    ~H"""
    <.search_input title="Cuenta" form={@form}/>
    """
  end

  def handle_event("search", _params, socket) do
    {:noreply, assign(socket, form: to_form(%{"search" => ""}))}
  end
  # handle_event
  def handle_event("inc", _, socket) do
    case socket.assigns.brightness do
      100 -> {:noreply, socket}
      _ -> {:noreply, 
            assign(socket, brightness: socket.assigns.brightness + 10)}
    end
  end
  
  def handle_event("dec", _, socket) do
    case socket.assigns.brightness do
      0 -> {:noreply, socket}
      _ -> {:noreply, assign(socket, brightness: socket.assigns.brightness - 10)}
    end
  end
end
