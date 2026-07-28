defmodule MovieMatchWeb.Components.Session.MoviePreferences do
  use MovieMatchWeb, :html

  attr :genres, :list, default: []
  attr :selected_genres, :list, default: []
  attr :runtime, :string, default: nil
  attr :selected_runtime, :string, default: nil
  attr :variant, :atom, default: :display, values: [:display, :filter]
  attr :expanded, :boolean, default: false

  def movie_preferences(assigns) do
    ~H"""
    <%= case @variant do %>
      <% :display -> %>
        <.display_preferences
          genres={@genres}
          selected_genres={@selected_genres}
          runtime={@runtime}
          selected_runtime={@selected_runtime}
        />

      <% :filter -> %>
        <.filter_preferences
          expanded={@expanded}
          genres={@genres}
          selected_genres={@selected_genres}
          runtime={@runtime}
          selected_runtime={@selected_runtime}
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
         <.genre_filter
              genres={@genres}
              selected_genres={@selected_genres}
            />
      </div>

      <.runtime_filter
            selected_runtime={@selected_runtime}
          />
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
          <.genre_filter
                genres={@genres}
                selected_genres={@selected_genres}
              />
         </div>


          <.runtime_filter
                selected_runtime={@selected_runtime}
              />
        </div>
      </div>

    </div>
    """
  end

  defp genre_filter(assigns) do
    ~H"""
    <div>
        <p class="font-semibold">
          Genres
        </p>

        <div class="mt-3 flex flex-wrap gap-2">
          <button
            :for={genre <- @genres}
            type="button"
            phx-click="toggle_genre"
            phx-value-genre={genre}
            class={[
              "badge",
              genre in @selected_genres &&
                "bg-violet-600 text-white border-violet-600",
              genre not in @selected_genres &&
                "badge-neutral"
            ]}
          >
            <%= genre %>
          </button>
        </div>
      </div>
    """
  end


  defp runtime_filter(assigns) do
    ~H"""
    <div class="mt-6">
      <p class="font-semibold">
        Runtime
      </p>

      <div class="mt-3 flex flex-col gap-2">

        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="runtime"
            value="any"
            checked={@selected_runtime == "any"}
            phx-click="set_runtime"
            phx-value-runtime="any"
          />
          Any runtime
        </label>


        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="runtime"
            value="short"
            checked={@selected_runtime == "short"}
            phx-click="set_runtime"
            phx-value-runtime="short"
          />
          Under 90 minutes
        </label>


        <label class="flex items-center gap-2">
          <input
            type="radio"
            name="runtime"
            value="medium"
            checked={@selected_runtime == "medium"}
            phx-click="set_runtime"
            phx-value-runtime="medium"
          />
          Under 120 minutes
        </label>

      </div>
    </div>
    """
  end
end