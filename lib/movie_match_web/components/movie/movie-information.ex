defmodule MovieMatchWeb.Components.Movie.MovieInformation do
  use Phoenix.Component

  attr :movie, :map, required: true

  def movie_information(assigns) do
    ~H"""
    <div class="flex h-full flex-col bg-slate-900 p-8">

      <h1 class="text-3xl font-bold">
        <%= @movie.title %>
      </h1>

      <div class="mt-3 flex flex-wrap gap-2 text-sm text-slate-400">
        <span><%= @movie.release_year %></span>
        <span>•</span>
        <span><%= Enum.join(@movie.genres, ", ") %></span>
        <span>•</span>
        <span><%= @movie.runtime %></span>
      </div>

      <div class="mt-8 flex-1 overflow-y-auto text-slate-300 leading-relaxed">
        <%= @movie.overview %>
      </div>

      <p class="mt-4 text-sm text-slate-500">
        Click for poster
      </p>

    </div>
    """
  end
end