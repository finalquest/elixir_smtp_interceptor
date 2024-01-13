defmodule SmtpInterceptorWeb.MailDashboard do
  use SmtpInterceptorWeb, :live_view

  import SmtpInterceptorWeb.MailDashboard.Search
  alias SmtpInterceptor.Mailer

  def mount(_params, _session, socket) do
    {:ok, 
      assign(socket, brightness: 10, 
                form: to_form(%{"search"=>""}),
                mails: [] 
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
        <div class="flex h-full">
          <ul class="divide-y-2 flex flex-col w-full">
              <li :for={mail <- @mails} class="p-4 cursor-pointer h-fit w-full bg-blue-50 hover:bg-blue-400">
                <div phx-click="select_mail" phx-value-email={mail.id}>
                  <p class="font-bold">De:</p>
                  <p><%= mail.from%></p>
                  <p class="font-bold">Destino:</p>
                  <p><%= mail.to%></p>
                </div>
              </li>
          </ul>
        </div>
      </div>
      <div class="flex basis-3/4 bg">
      </div>
    </div>
    """
  end

  def handle_event("search", %{"search" => search}, socket) do
    {:noreply, assign(socket, form: to_form(%{"search" => ""}),
      mails: Mailer.search_by_account(search))}
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

  def handle_event("select_mail", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
