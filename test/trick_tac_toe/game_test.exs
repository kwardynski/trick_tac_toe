defmodule TrickTacToe.GameTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game
  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player

  describe "place_marker/3" do
    test "has a chance of placing the other player's marker" do
      player_1 = %Player{number: 1, marker: :x}
      board = Board.initialize_board()
      test_ind = 1

      markers =
        for _ <- 1..100 do
          player_1
          |> Game.place_player_marker(test_ind, board)
          |> Map.get(:tiles)
          |> Map.get(test_ind)
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
end
