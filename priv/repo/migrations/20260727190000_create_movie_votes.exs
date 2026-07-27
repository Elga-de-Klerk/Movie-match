defmodule MovieMatch.Repo.Migrations.CreateMovieVotes do
  use Ecto.Migration

  def change do
    create table(:movie_votes) do
      add :session_id,
          references(:sessions, type: :string, on_delete: :delete_all),
          null: false

      add :participant_id,
          references(:participants, on_delete: :delete_all),
          null: false

      add :movie_id, :integer, null: false
      add :liked, :boolean, null: false

      timestamps()
    end

    create index(:movie_votes, [:session_id])
    create index(:movie_votes, [:participant_id])
    create index(:movie_votes, [:movie_id])
  end
end