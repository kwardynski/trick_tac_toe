defmodule TrickTacToe.Game.BoardTest do
  use ExUnit.Case, async: true

  alias GamesEngine.Grid
  alias GamesEngine.Grid.Tile
  alias TrickTacToe.Game.Board

  setup do
    [board: Board.initialize_board()]
  end

  describe "place_marker/3" do
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

  describe "check_end_game_conditions/1" do
    test "returns {:ok, :player_one_win} if row of x's found", %{board: board} do
      paths = [
        [0, 3, 6],
        [3, 4, 5],
        [0, 4, 8]
      ]

      Enum.each(paths, fn path ->
        filled_board = populate_board(board, path, [])
        assert {:ok, :player_one_win} == Board.check_end_game_conditions(filled_board)
      end)
    end

    test "returns {:ok, :player_two_win} if row of o's found", %{board: board} do
      paths = [
        [2, 5, 8],
        [0, 1, 2],
        [2, 4, 6]
      ]

      Enum.each(paths, fn path ->
        filled_board = populate_board(board, [], path)
        assert {:ok, :player_two_win} == Board.check_end_game_conditions(filled_board)
      end)
    end

    test "returns {:ok, :draw} if board is full but no complete row found", %{board: board} do
      x_tiles = [0, 2, 4, 5, 7]
      o_tiles = [1, 3, 6, 8]

      filled_board = populate_board(board, x_tiles, o_tiles)
      assert {:ok, :draw} == Board.check_end_game_conditions(filled_board)
    end

    test "returns {:ok, :continue} if board is not full and no row found", %{board: board} do
      x_tiles = [0, 2, 4, 5]
      o_tiles = [1, 3, 6]

      filled_board = populate_board(board, x_tiles, o_tiles)
      assert {:ok, :continue} == Board.check_end_game_conditions(filled_board)
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
