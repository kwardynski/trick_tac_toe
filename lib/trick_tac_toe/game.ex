defmodule TrickTacToe.Game do
  alias GamesEngine.Grid
  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player

  @chance_of_other_marker 0.20

  @doc """
  Places a marker on the board for a player
  """
  def place_marker(%Player{} = player, ind, %Grid{} = board) do
    marker = maybe_randomize_marker(player)
    Board.place_marker(board, ind, marker)
  end

  defp maybe_randomize_marker(player) do
    if :rand.uniform() <= @chance_of_other_marker,
      do: other_marker(player),
      else: player.marker
  end

  defp other_marker(:o), do: :x
  defp other_marker(:x), do: :o
end
