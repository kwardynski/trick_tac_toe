defmodule TrickTacToe.GameTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game
  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player

  setup do
    [game: Game.new()]
  end

  describe "place_marker/2" do
    test "successfully places a marker", %{game: game} do
      {:ok, %Game{board: board}} = Game.place_marker(game, 0)
      %{tiles: %{0 => %{attributes: %{marker: marker}}}} = board
      refute is_nil(marker)
    end

    test "has a chance of placing the other player's marker", %{game: game} do
      markers =
        for _ <- 1..100 do
          {:ok, %Game{} = game} = Game.place_marker(game, 0)

          game
          |> Map.get(:board)
          |> Map.get(:tiles)
          |> Map.get(0)
          |> Map.get(:attributes)
          |> Map.get(:marker)
        end

      assert Enum.any?(markers, &(&1 == :o))
    end

    test "successfully transitions state between players", %{game: game} do
      assert {:ok, %Game{state: :player_two_turn} = game} = Game.place_marker(game, 0)
      assert {:ok, %Game{state: :player_one_turn}} = Game.place_marker(game, 1)
    end

    test "successfully updates player win count if win encountered", %{game: game} do
      x_tiles = [0, 3, 6]
      board = populate_board(game.board, x_tiles, [])
      game = %{game | board: board}

      {:ok, %Game{} = game} = Game.place_marker(game, 1)

      %{
        state: :player_one_win,
        player_one: %Player{
          wins: 1
        }
      } = game
    end

    test "returns error if attempting to place marker on occupied", %{game: game} do
      {:ok, updated_game} = Game.place_marker(game, 0)
      assert {{:error, :tile_occupied}, ^updated_game} = Game.place_marker(updated_game, 0)
    end
  end

  describe "reset_game/1" do
    test "resets to initial state", %{game: game} do
      updated_game = %{game | state: :player_two_win}
      assert {:ok, %Game{state: :player_one_turn}} = Game.reset_game(updated_game)
    end

    test "resets the board", %{game: game} do
      x_tiles = [0, 2, 4]
      o_tiles = [1, 3, 4]
      board = populate_board(game.board, x_tiles, o_tiles)
      game = %{game | board: board}

      {:ok, %Game{board: updated_board}} = Game.reset_game(game)

      Enum.each(updated_board.tiles, fn {_ind, tile} ->
        assert is_nil(tile.attributes.marker)
      end)
    end

    test "does not clear player stats", %{game: game} do
      %{player_one: player_one, player_two: player_two} = game
      player_one_with_wins = %{player_one | wins: 2}
      player_two_with_wins = %{player_two | wins: 3}

      updated_game = %{game | player_one: player_one_with_wins, player_two: player_two_with_wins}

      assert {:ok, new_game} = Game.reset_game(updated_game)

      assert %Game{
               player_one: %Player{wins: 2},
               player_two: %Player{wins: 3}
             } = new_game
    end
  end

  defp populate_board(board, x_tiles, o_tiles) do
    board
    |> fill_tiles(x_tiles, :x)
    |> fill_tiles(o_tiles, :o)
  end

  defp fill_tiles(board, tiles, marker) do
    Enum.reduce(tiles, board, fn ind, board ->
      Board.place_marker(board, ind, marker)
    end)
  end
end
