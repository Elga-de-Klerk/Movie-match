defmodule MovieMatch.Movies.TMDB do
  @base_url "https://api.themoviedb.org/3"

  def popular_movies do
    Req.get!(
      "#{@base_url}/movie/popular",
      params: [
        api_key: api_key(),
        language: "en-US"
      ]
    ).body["results"]
  end

  defp api_key do
    Application.fetch_env!(:movie_match, :tmdb_api_key)
  end
end