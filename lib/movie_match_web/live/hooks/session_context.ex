defmodule MovieMatchWeb.Live.Hooks.SessionContext do
  import Phoenix.LiveView
  import Phoenix.Component

  alias MovieMatch.Sessions

  def on_mount(:session_context, params, _session, socket) do
    participant =
      case params["participant_id"] do
        nil ->
          nil

        id ->
          Sessions.get_participant_by_id!(String.to_integer(id))
      end

    {:cont,
     socket
     |> assign(:participant, participant)
     |> assign(:participant_id, participant && participant.id)}
  end
end