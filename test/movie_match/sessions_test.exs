defmodule MovieMatch.SessionsTest do
  use MovieMatch.DataCase

  alias MovieMatch.Sessions

  describe "sessions" do
    alias MovieMatch.Sessions.Session

    import MovieMatch.SessionsFixtures

    @invalid_attrs %{"\\": nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Sessions.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Sessions.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{"\\": "some \\"}

      assert {:ok, %Session{} = session} = Sessions.create_session(valid_attrs)
      assert session.\ == "some \\"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{"\\": "some updated \\"}

      assert {:ok, %Session{} = session} = Sessions.update_session(session, update_attrs)
      assert session.\ == "some updated \\"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, @invalid_attrs)
      assert session == Sessions.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Sessions.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Sessions.change_session(session)
    end
  end

  describe "participants" do
    alias MovieMatch.Sessions.Participant

    import MovieMatch.SessionsFixtures

    @invalid_attrs %{"\\": nil}

    test "list_participants/0 returns all participants" do
      participant = participant_fixture()
      assert Sessions.list_participants() == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert Sessions.get_participant!(participant.id) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      valid_attrs = %{"\\": "some \\"}

      assert {:ok, %Participant{} = participant} = Sessions.create_participant(valid_attrs)
      assert participant.\ == "some \\"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_participant(@invalid_attrs)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = participant_fixture()
      update_attrs = %{"\\": "some updated \\"}

      assert {:ok, %Participant{} = participant} = Sessions.update_participant(participant, update_attrs)
      assert participant.\ == "some updated \\"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = participant_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_participant(participant, @invalid_attrs)
      assert participant == Sessions.get_participant!(participant.id)
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = Sessions.delete_participant(participant)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_participant!(participant.id) end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = Sessions.change_participant(participant)
    end
  end
end
