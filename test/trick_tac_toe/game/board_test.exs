defmodule TrickTacToe.Game.BoardTest do
  use ExUnit.Case, async: true

  alias GamesEngine.Grid
  alias GamesEngine.Grid.Tile
  alias TrickTacToe.Game.Board

  describe "place_marker/3" do
    setup do
      [
        board: Board.initialize_board()
      ]
    end

    test "returns error if marker not within bounds of board", %{board: board} do
      assert {:error, "12 exceeds the bounds of a 3x3 board"} == Board.place_marker(board, 12, :x)
    end

    test "returns error if invalid marker supplied", %{board: board} do
      assert {:error, "invalid marker"} == Board.place_marker(board, 3, :invalid)
    end

    test "returns error if tile already has a marker in it", %{board: board} do
      assert {:error, "marker present in tile"} =
               board
               |> Board.place_marker(3, :x)
               |> Board.place_marker(3, :x)
    end

    test "successfully places a valid marker in an empty tile", %{board: board} do
      assert %Grid{
               tiles: %{
                 3 => %Tile{
                   attributes: %{marker: :x}
                 }
               }
             } = Board.place_marker(board, 3, :x)
    end
  end
end
