defmodule MovieMatchWeb.Components.Session.MoviePreferences do
  use MovieMatchWeb, :html

  attr :genres, :list, default: []
  attr :runtime, :string, default: nil
  attr :variant, :atom, default: :display, values: [:display, :filter]
  attr :expanded, :boolean, default: false

  def movie_preferences(assigns) do
    ~H"""
    <%= case @variant do %>
      <% :display -> %>
        <.display_preferences
          genres={@genres}
          runtime={@runtime}
        />

      <% :filter -> %>
        <.filter_preferences
          expanded={@expanded}
          genres={@genres}
          runtime={@runtime}
        />
    <% end %>
    """
  end


  defp display_preferences(assigns) do
    ~H"""
    <.panel>
      <.heading>
        Movie preferences
      </.heading>
      <.subtext class="mt-2">
        Adjust what kind of movies you're in the mood for
      </.subtext>

      <div class="mt-4 flex flex-wrap gap-2">
        <span
          :for={genre <- @genres}
          class="badge badge-neutral"
        >
          <%= genre %>
        </span>
      </div>

      <.caption :if={@runtime}>
        Runtime: <%= @runtime %>
      </.caption>
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
        <div class="flex items-center gap-3">
          <div class="text-left">
            <p class="font-semibold">
              Movie preferences
            </p>

            <p class="text-sm text-slate-400">
              Adjust what kind of movies you're in the mood for
            </p>
          </div>
        </div>

        <.icon
          name={if @expanded,
            do: "hero-chevron-up",
            else: "hero-chevron-down"}
        />
      </button>


      <div
        :if={@expanded}
        class="absolute left-0 right-0 top-full z-50"
      >
        <div class="rounded-2xl bg-slate-950 p-6">
          <div>
            <p class="mb-3 font-semibold">
              Genres
            </p>

            <div class="flex flex-wrap gap-2">
              <span
                :for={genre <- @genres}
                class="badge badge-neutral"
              >
                <%= genre %>
              </span>
            </div>
          </div>


          <div :if={@runtime} class="mt-6">
            <p class="font-semibold">
              Runtime
            </p>

            <p class="text-sm text-slate-400">
              <%= @runtime %>
            </p>
          </div>
        </div>
      </div>

    </div>
    """
  end
end