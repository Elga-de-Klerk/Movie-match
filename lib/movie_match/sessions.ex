defmodule MovieMatch.Sessions do
  import Ecto.Query, warn: false

  alias MovieMatch.Repo
  alias MovieMatch.Sessions.Session

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def get_session_by_id(id) do
      Repo.get_by(Session, id: id)
  end

  def get_session_by_id!(id) do
    Repo.get_by!(Session, id: id)
  end

  alias MovieMatch.Sessions.Participant

  def add_participant(attrs) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  def get_participant_by_id!(id) do
    Repo.get!(Participant, id)
  end

  def count_participants(session_id) do
    Participant
    |> where(session_id: ^session_id)
    |> Repo.aggregate(:count)
  end

  alias MovieMatch.Sessions.MovieVote

  def create_movie_vote(attrs) do
    %MovieVote{}
    |> MovieVote.changeset(attrs)
    |> Repo.insert()
  end

  def check_for_match(session_id, movie_id) do
  required_likes = max(count_participants(session_id), 2)

    liked_count =
      MovieVote
      |> where(session_id: ^session_id, movie_id: ^movie_id, liked: true)
      |> select([v], count(v.participant_id, :distinct))
      |> Repo.one()

    liked_count >= required_likes
  end

end
