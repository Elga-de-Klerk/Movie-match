defmodule MovieMatchWeb.SessionLive.Join do
  use MovieMatchWeb, :live_view

  alias MovieMatch.Sessions

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:code, "")}
  end

  def handle_event("update_code", %{"code" => code}, socket) do
    {:noreply, assign(socket, :code, code)}
  end

  def handle_event("join", %{"code" => code}, socket) do
    code =
      code
      |> String.trim()
      |> String.upcase()

    case Sessions.get_session_by_id(code) do
      nil ->
        {:noreply,
         put_flash(socket, :error, "Session not found")}

      _session ->
        {:noreply,
         push_navigate(socket, to: "/session/#{code}")}
    end
  end
end