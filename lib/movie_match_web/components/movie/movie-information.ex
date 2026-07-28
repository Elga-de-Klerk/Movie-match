defmodule MovieMatchWeb.Components.Movie.MovieInformation do
  use MovieMatchWeb, :component

  import MovieMatchWeb.Components.Movie.MovieDetails

  attr :movie, :map, required: true

  def movie_information(assigns) do
    ~H"""
    <div class="flex h-full flex-col bg-slate-900 p-8">

      <.heading>
        <%= @movie.title %>
      </.heading>

      <.movie_details movie={@movie} />

      <div class="mt-8 flex-1 overflow-y-auto text-slate-300 leading-relaxed">
        <%= @movie.overview %>
      </div>

      <.caption>Click for poster</.caption>

    </div>
    """
  end
end