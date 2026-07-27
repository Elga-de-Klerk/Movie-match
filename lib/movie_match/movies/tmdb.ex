defmodule MovieMatch.Movies.TMDB do
  @base_url "https://api.themoviedb.org/3"

  def popular_movies do
    Req.get!(
      "#{@base_url}/movie/popular",
      params: [api_key: api_key(), language: "en-US"]
    ).body["results"]
  end

  def genres do
    Req.get!(
      "#{@base_url}/genre/movie/list",
      params: [api_key: api_key(), language: "en-US"]
    ).body["genres"]
    |> Map.new(fn %{"id" => id, "name" => name} -> {id, name} end)
  end

  def movie_details(id) do
    Req.get!(
      "#{@base_url}/movie/#{id}",
      params: [api_key: api_key(), language: "en-US"]
    ).body
  end

  defp api_key do
    Application.fetch_env!(:movie_match, :tmdb_api_key)
  end
end