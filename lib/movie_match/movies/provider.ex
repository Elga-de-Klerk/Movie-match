defmodule MovieMatch.Movies.Provider do
  alias MovieMatch.Movies.Movie
  alias MovieMatch.Movies.TMDB

  def discover do
    TMDB.popular_movies()
    |> Enum.map(&convert_movie/1)
  end

  defp convert_movie(movie) do
    %Movie{
      id: movie["id"],
      title: movie["title"],
      overview: movie["overview"],
      poster:
        "https://image.tmdb.org/t/p/w500#{movie["poster_path"]}",
      release_year:
        movie["release_date"]
        |> String.slice(0, 4),
      genres: [],
      runtime: nil
    }
  end
end