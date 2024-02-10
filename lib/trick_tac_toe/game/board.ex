defmodule TrickTacToe.Game.Board do
  alias GamesEngine.Grid
  alias GamesEngine.Validations.GridValidations

  @board_size 3
  @default_tile_attributes %{marker: nil}
  @markers [:x, :o]

  @doc """
  Creates an empty board for a new Trick Tac Toe game
  """
  def initialize_board() do
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
  defp validate_marker(_), do: {:error, "invalid marker"}

  defp validate_tile_empty(tiles, ind) do
    %{^ind => %{attributes: %{marker: marker}}} = tiles

    if is_nil(marker),
      do: :ok,
      else: {:error, "marker present in tile"}
  end
end
