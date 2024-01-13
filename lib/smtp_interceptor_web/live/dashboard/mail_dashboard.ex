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
    <div class="flex w-screen p-4 h-screen divide-x divide-gray-200">
      <div class="flex flex-col basis-2/4 pl-4 divide-y-2 divide-gray-200">
        <div class="pb-2">
          <.search_input title="Cuenta" form={@form}/>
        </div>
        <div class="h-30 bg-sky-50">

        </div>
      </div>
      <div class="flex basis-3/4">
         
      </div>
      
    </div>
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
