defmodule MovieMatch.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :string, primary_key: true
      add :selected_services, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create unique_index(:sessions, [:id])
  end
end
