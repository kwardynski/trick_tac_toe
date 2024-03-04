defmodule TrickTacToe.GameTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game
  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player

  setup do
    [game: Game.new()]
  end

  describe "Placing a marker" do
    test "successfully places a marker", %{game: game} do
      {:reply, _state, %{board: board}} = Game.handle_call({:place_marker, 0}, [], game)
      %{tiles: %{0 => %{attributes: %{marker: marker}}}} = board
      refute is_nil(marker)
    end

    test "has a chance of placing the other player's marker", %{game: game} do
      markers =
        for _ <- 1..100 do
          {:reply, _state, game} = Game.handle_call({:place_marker, 0}, [], game)

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
      assert {:reply, :player_two_turn, game} = Game.handle_call({:place_marker, 0}, [], game)
      assert {:reply, :player_one_turn, _game} = Game.handle_call({:place_marker, 1}, [], game)
    end

    test "successfully updates player win count if win encountered", %{game: game} do
      x_tiles = [0, 3, 6]
      board = populate_board(game.board, x_tiles, [])
      game = %{game | board: board}

      {:reply, :player_one_win, game} = Game.handle_call({:place_marker, 1}, [], game)

      %Game{
        state: :player_one_win,
        player_one: %Player{
          wins: 1
        }
      } = game
    end

    test "returns error if attempting to place marker on occupied", %{game: game} do
      {:reply, _state, updated_game} = Game.handle_call({:place_marker, 0}, [], game)
      {:reply, error, error_game} = Game.handle_call({:place_marker, 0}, [], updated_game)

      assert error == {:error, :tile_occupied}
      assert error_game == updated_game
    end

    test "returns error if board is full", %{game: game} do
      game_filled_board =
        Enum.reduce(0..9, game, fn ind, game ->
          {:reply, _state, game} = Game.handle_call({:place_marker, ind}, [], game)
          game
        end)

      assert {:reply, error, error_game} =
               Game.handle_call({:place_marker, 0}, [], game_filled_board)

      assert error == {:error, :invalid_state}
      assert game_filled_board == error_game
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
