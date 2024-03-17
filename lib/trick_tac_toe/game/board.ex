defmodule TrickTacToe.Game.Board do
  @moduledoc false

  alias GamesEngine.Grid
  alias GamesEngine.Validations.GridValidations

  @board_size 3
  @default_tile_attributes %{marker: nil}
  @markers [:x, :o]

  @win_paths [
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]

  @doc """
  Creates an empty board for a new Trick Tac Toe game
  """
  def initialize_board do
    board = Grid.new(@board_size, @board_size)
    Grid.populate(board, @default_tile_attributes)
  end

  @doc """
  Places a marker on the board
  """
  def place_marker(board, ind, marker) do
    with(
      :ok <- GridValidations.ind_within_bounds(ind, board),
      :ok <- validate_marker(marker),
      :ok <- validate_tile_empty(board.tiles, ind)
    ) do
      Grid.update_tile_attribute(board, ind, :marker, marker)
    end
  end

  defp validate_marker(marker) when marker in @markers, do: :ok
  defp validate_marker(_), do: {:error, :invalid_marker}

  defp validate_tile_empty(tiles, ind) do
    %{^ind => %{attributes: %{marker: marker}}} = tiles

    if is_nil(marker),
      do: :ok,
      else: {:error, :tile_occupied}
  end

  @doc """
  Checks if end-game state has been reached on the board
  """
  def check_end_game_conditions(%Grid{} = board) do
    %{tiles: tiles} = board

    win_result = check_for_winner(@win_paths, tiles)
    board_full? = check_board_full(tiles)

    cond do
      win_result in [:player_one_win, :player_two_win] -> {:ok, win_result}
      board_full? -> {:ok, :draw}
      true -> {:ok, :continue}
    end
  end

  defp check_for_winner([], _tiles), do: :no_winner

  defp check_for_winner([path | paths], tiles) do
    path_values =
      Enum.map(path, fn ind ->
        tiles
        |> Map.get(ind)
        |> Map.get(:attributes)
        |> Map.get(:marker)
      end)

    cond do
      Enum.all?(path_values, &(&1 == :x)) -> :player_one_win
      Enum.all?(path_values, &(&1 == :o)) -> :player_two_win
      true -> check_for_winner(paths, tiles)
    end
  end

  defp check_board_full(tiles),
    do: Enum.all?(tiles, fn {_ind, %{attributes: %{marker: marker}}} -> !is_nil(marker) end)
end
