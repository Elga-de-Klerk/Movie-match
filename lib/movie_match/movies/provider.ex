defmodule MovieMatch.Movies.Provider do
  alias MovieMatch.Movies.Movie
  alias MovieMatch.Movies.Cache
  alias MovieMatch.Movies.TMDB

  def discover(selected_services) do
    genre_lookup = Cache.genres()
    provider_ids = TMDB.provider_ids_for(selected_services)

    movies =
      case provider_ids do
        [] -> Cache.popular_movies()
        ids -> Cache.movies_for_providers(ids)
      end

    Enum.map(movies, &convert_movie(&1, genre_lookup))
  end

  def enrich_with_runtime(%Movie{id: id} = movie) do
      %{movie | runtime: Cache.movie_details(id)["runtime"]}
  end

  defp convert_movie(movie, genre_lookup) do
    genre_names =
      movie["genre_ids"]
      |> Enum.map(&genre_lookup[&1])
      |> Enum.reject(&is_nil/1)

    %Movie{
      id: movie["id"],
      title: movie["title"],
      overview: movie["overview"],
      poster: "https://image.tmdb.org/t/p/w342#{movie["poster_path"]}",
      release_year: movie["release_date"] |> String.slice(0, 4),
      genres: genre_names,
      runtime: nil
    }
  end
end