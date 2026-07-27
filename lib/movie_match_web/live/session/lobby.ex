defmodule MovieMatchWeb.SessionLive.Lobby do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  import MovieMatchWeb.Components.Session.SessionHeader
  import MovieMatchWeb.Components.Session.JoinForm
  import MovieMatchWeb.Components.Session.ParticipantList


  def mount(%{"id" => id}, _session, socket) do
    session = Sessions.get_session_by_id!(id)

    {:ok,
     socket
     |> assign(:session, session)
     |> assign(:participants, Sessions.list_participants(id))
     |> assign(:name, "")
     |> assign(:joined, false)}
  end

  def handle_event("update_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, :name, name)}
  end

  def handle_event("join_session", _params, socket) do
    {:ok, _participant} =
      Sessions.add_participant(%{
        name: socket.assigns.name,
        session_id: socket.assigns.session.id
      })

    {:noreply,
     socket
     |> assign(:participants, Sessions.list_participants(socket.assigns.session.id))
     |> assign(:joined, true)}
  end

  def render(assigns) do
    ~H"""
    <main class="min-h-screen bg-slate-950 text-white">
      <div class="mx-auto flex min-h-screen max-w-xl items-center px-6 py-12">
        <div class="w-full">

          <.session_header session={@session}/>

          <%= unless @joined do %>
            <.join_form name={@name}/>
          <% end %>

          <.participant_list participants={@participants}/>

          <button
            class="mt-6 w-full rounded-xl bg-violet-600 px-6 py-3 font-semibold transition hover:bg-violet-500"
          >
            Start Swiping
          </button>

        </div>
      </div>
    </main>
    """
  end
end