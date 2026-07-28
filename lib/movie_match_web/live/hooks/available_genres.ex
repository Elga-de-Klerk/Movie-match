defmodule MovieMatchWeb.Live.Hooks.AvailableGenres do
  import Phoenix.Component

  alias MovieMatch.Movies.Provider

  def on_mount(:available_genres, _params, _session, socket) do
    {:cont, assign(socket, :available_genres, Provider.available_genres())}
  end
end