defmodule MovieMatchWeb.SessionLive.Join do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:code, "")
     |> assign(:error, nil)}
  end

  def handle_event("update_code", %{"code" => code}, socket) do
    {:noreply,
     socket
     |> assign(:code, code)
     |> assign(:error, nil)}
  end

  def handle_event("join", %{"code" => code}, socket) do
    code =
      code
      |> String.trim()
      |> String.upcase()

    IO.inspect(code, label: "Code")

    case Sessions.get_session_by_id(code) do
      nil ->
        {:noreply,
         socket
         |> assign(:error, "No session found with this code.")
         |> assign(:code, code)}

      _session ->
        {:noreply,
         socket
         |> assign(:error, nil)
         |> push_navigate(to: "/session/#{code}")}
    end
  end
end