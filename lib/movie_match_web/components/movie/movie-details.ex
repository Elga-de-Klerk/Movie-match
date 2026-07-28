defmodule MovieMatchWeb.Components.Movie.MovieDetails do
  use MovieMatchWeb, :component

  import MovieMatchWeb.Components.Movie.Formatting

  def movie_details(assigns) do
    ~H"""
      <div class="mt-3 flex flex-wrap gap-2 text-sm text-slate-400">
        <span><%= @movie.release_year %></span>
        <span>•</span>
        <span><%= Enum.join(@movie.genres, ", ") %></span>
        <span>•</span>
        <span><%= format_runtime(@movie.runtime) %></span>
      </div>
    """
  end
end