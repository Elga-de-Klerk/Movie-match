defmodule MovieMatchWeb.Components.Session.MoviePreferences do
  use MovieMatchWeb, :component

  attr :genres, :list, default: []
  attr :genre_mode, :atom, default: :or, values: [:or, :and]
  attr :selected_genres, :list, default: []
  attr :variant, :atom, default: :display, values: [:display, :filter]
  attr :expanded, :boolean, default: false

  def movie_preferences(assigns) do
    ~H"""
    <%= case @variant do %>
      <% :display -> %>
        <.display_preferences
          genres={@genres}
          selected_genres={@selected_genres}
          genre_mode={@genre_mode}
        />
      <% :filter -> %>
        <.filter_preferences
          expanded={@expanded}
          genres={@genres}
          selected_genres={@selected_genres}
          genre_mode={@genre_mode}
        />
    <% end %>
    """
  end

  defp display_preferences(assigns) do
    ~H"""
    <.panel>
      <.heading>Movie preferences</.heading>
      <.subtext class="mt-2">
        Adjust what kind of movies you're in the mood for
      </.subtext>

      <div class="mt-4">
        <.genre_filter genres={@genres} selected_genres={@selected_genres} genre_mode={@genre_mode} />
      </div>
    </.panel>
    """
  end

  defp filter_preferences(assigns) do
    ~H"""
    <div class="relative">
      <button
        type="button"
        phx-click="toggle_movie_preferences"
        class="flex w-full items-center justify-between"
      >
        <div class="text-left">
          <p class="font-semibold">Movie preferences</p>
          <.subtext>Adjust what kind of movies you're in the mood for</.subtext>
        </div>

        <.icon name={if @expanded, do: "hero-chevron-up", else: "hero-chevron-down"} />
      </button>

      <div :if={@expanded} class="absolute left-0 right-0 top-full z-50">
        <.panel class="bg-slate-950">
          <.genre_filter genres={@genres} selected_genres={@selected_genres} genre_mode={@genre_mode} />
        </.panel>
      </div>
    </div>
    """
  end

  defp genre_filter(assigns) do
    ~H"""
    <div>
      <p class="font-semibold">Genres</p>

      <button
        type="button"
        phx-click="toggle_genre_mode"
        class="text-sm font-semibold text-violet-400 hover:text-violet-300"
      >
        Match: <%= if @genre_mode == :and, do: "all", else: "any" %>
      </button>

      <div class="mt-3 flex flex-wrap gap-2">
        <button
          :for={genre <- @genres}
          type="button"
          phx-click="toggle_genre"
          phx-value-genre={genre}
          class={[
            "rounded-xl border-2 px-4 py-2 text-sm font-semibold transition",
            genre in @selected_genres && "border-violet-500 bg-violet-500/10 text-white",
            genre not in @selected_genres && "border-slate-800 bg-slate-900 text-slate-300 hover:border-slate-600"
          ]}
        >
          <%= genre %>
        </button>
      </div>
    </div>
    """
  end
end