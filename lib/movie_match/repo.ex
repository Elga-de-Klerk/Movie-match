defmodule MovieMatch.Repo do
  use Ecto.Repo,
    otp_app: :movie_match,
    adapter: Ecto.Adapters.Postgres
end
