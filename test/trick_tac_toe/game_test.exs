defmodule TrickTacToe.GameTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game
  alias TrickTacToe.Game.Board

  describe "transition_state/2" do
    setup do
      [game: Game.new()]
    end

    test ":player_one_turn -> :player_two_turn", %{game: game} do
      assert %Game{state: :player_two_turn} = Game.transition_state(game, :continue)
    end

    test ":player_two_turn -> :player_two_turn", %{game: game} do
      assert %Game{state: :player_one_turn} =
               game
               |> set_state(:player_two_turn)
               |> Game.transition_state(:continue)
    end

    test "transitions to :end_game", %{game: game} do
      initial_states = [:player_one_turn, :player_two_turn]
      end_game_transitions = [:draw, :player_one_win, :player_two_win]

      for state <- initial_states, transition <- end_game_transitions do
        assert %Game{state: :end_game} =
                 game
                 |> set_state(state)
                 |> Game.transition_state(transition)
      end
    end

    test "start new game", %{game: game} do
      assert %Game{state: :player_one_turn} =
               game
               |> set_state(:end_game)
               |> Game.transition_state(:new_game)
    end
  end

  describe "place_marker/3" do
    setup do
      [game: Game.new()]
    end

    test "successfully places a marker", %{game: game} do
      %Game{board: board} = Game.place_marker(game, 0)
      %{tiles: %{0 => %{attributes: %{marker: marker}}}} = board
      refute is_nil(marker)
    end

    test "has a chance of placing the other player's marker", %{game: game} do
      markers =
        for _ <- 1..100 do
          game
          |> Game.place_marker(0)
          |> Map.get(:board)
          |> Map.get(:tiles)
          |> Map.get(0)
          |> Map.get(:attributes)
          |> Map.get(:marker)
        end

      assert Enum.any?(markers, &(&1 == :o))
    end
  end

  describe "check_end_game_conditions/1" do
    test "returns :player_one_win if row of x's found" do
      paths = [
        [0, 3, 6],
        [3, 4, 5],
        [0, 4, 8]
      ]

      Enum.each(paths, fn path ->
        assert :player_one_win ==
                 Board.initialize_board()
                 |> fill_tiles(path, :x)
                 |> Game.check_end_game_conditions()
      end)
    end

    test "returns :player_two_win if row of o's found" do
      paths = [
        [2, 5, 8],
        [0, 1, 2],
        [2, 4, 6]
      ]

      Enum.each(paths, fn path ->
        assert :player_two_win ==
                 Board.initialize_board()
                 |> fill_tiles(path, :o)
                 |> Game.check_end_game_conditions()
      end)
    end

    test "returns :draw if board is full but no complete row found" do
      x_tiles = [0, 2, 4, 5, 7]
      o_tiles = [1, 3, 6, 8]

      assert :draw =
               Board.initialize_board()
               |> fill_tiles(x_tiles, :x)
               |> fill_tiles(o_tiles, :o)
               |> Game.check_end_game_conditions()
    end

    test "returns :continue if board is not full and no row found" do
      x_tiles = [0, 2, 4, 5]
      o_tiles = [1, 3, 6]

      assert :continue =
               Board.initialize_board()
               |> fill_tiles(x_tiles, :x)
               |> fill_tiles(o_tiles, :o)
               |> Game.check_end_game_conditions()
    end
  end

  defp fill_tiles(board, tiles, marker) do
    Enum.reduce(tiles, board, fn ind, board ->
      Board.place_marker(board, ind, marker)
    end)
  end

  defp set_state(game, state) do
    %{game | state: state}
  end
end
