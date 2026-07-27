defmodule MovieMatch.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :session_id, references(:sessions, column: :id, type: :string),
        null: false

      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:participants, [:session_id])
  end
end
