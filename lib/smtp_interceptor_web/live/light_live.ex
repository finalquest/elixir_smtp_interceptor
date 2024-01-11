defmodule SmtpInterceptorWeb.LightLive do
  use SmtpInterceptorWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 10), layout: false}
  end
  
  # render
  def render(assigns) do
    ~H"""
     <h1 class="text-red-500 font-bold text-2xl">Light</h1> 
     <div class="flex flex-col items-center bg-gray-500 m-3 p-3">
        <div class="bg-pink-500 w-3/5 rounded-r h-10" > 
            <span class="bg-blue-500 flex h-full items-center justify-center" style={"width: #{@brightness}%"}>
            <%= @brightness %>%
            </span>
        </div>
        <div class="flex justify-center w-full mt-5">
          <button phx-click="inc" class="hover:bg-blue-800 aspect-square w-11 bg-blue-900 mr-11">+</button>
          <button phx-click="dec" class="hover:bg-sky-400 aspect-square w-11 bg-sky-500">-</button>
        </div>
     </div>
    """
  end

  # handle_event
  def handle_event("inc", _, socket) do
    case socket.assigns.brightness do
      100 -> {:noreply, socket}
      _ -> {:noreply, assign(socket, brightness: socket.assigns.brightness + 10)}
    end
  end
  
  def handle_event("dec", _, socket) do
    case socket.assigns.brightness do
      0 -> {:noreply, socket}
      _ -> {:noreply, assign(socket, brightness: socket.assigns.brightness - 10)}
    end
  end
end
