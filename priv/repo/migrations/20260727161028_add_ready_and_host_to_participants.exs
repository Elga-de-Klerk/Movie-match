defmodule MovieMatch.Repo.Migrations.AddReadyAndHostToParticipants do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :ready, :boolean, default: false
      add :host, :boolean, default: false
    end
  end
end
