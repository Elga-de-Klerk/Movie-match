defmodule MovieMatchWeb.Components.Movie.MovieCover do
  use Phoenix.Component

  attr :movie, :map, required: true

  def movie_cover(assigns) do
    ~H"""
    <div class="flex h-full flex-col bg-slate-900">

      <div class="flex h-[30rem] items-center justify-center p-6">
        <img
          src={@movie.poster}
          alt={@movie.title}
          class="h-full rounded-2xl object-contain shadow-lg"
        />
      </div>

      <div class="flex-1 px-6 pb-6">
        <h1 class="text-3xl font-bold">
          <%= @movie.title %>
        </h1>

        <div class="mt-3 flex flex-wrap gap-2 text-sm text-slate-400">
          <span><%= @movie.year %></span>
          <span>•</span>
          <span><%= Enum.join(@movie.genres, ", ") %></span>
          <span>•</span>
          <span><%= @movie.runtime %></span>
        </div>

        <p class="mt-4 text-sm text-slate-500">
          Click for description
        </p>
      </div>

    </div>
    """
  end
end