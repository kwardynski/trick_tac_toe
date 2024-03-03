defmodule TrickTacToe.Games.StatesTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game.States

  describe "transition/2" do
    test ":player_one_turn -> :player_two_turn" do
      assert {:ok, :player_two_turn} = States.transition(:player_one_turn, :continue)
    end

    test ":player_two_turn -> :player_two_turn" do
      assert {:ok, :player_one_turn} = States.transition(:player_two_turn, :continue)
    end

    test "transitions to :end_game" do
      initial_states = [:player_one_turn, :player_two_turn]
      end_game_transitions = [:draw, :player_one_win, :player_two_win]

      for state <- initial_states, transition <- end_game_transitions do
        assert {:ok, :end_game} = States.transition(state, transition)
      end
    end

    test "start new game" do
      assert {:ok, :player_one_turn} = States.transition(:end_game, :new_game)
    end
  end
end
