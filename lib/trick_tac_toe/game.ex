defmodule TrickTacToe.Game do
  alias GamesEngine.Grid
  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player

  @chance_of_other_marker 0.20

  @doc """
  Places a marker on the board for a player
  """
  def place_player_marker(%Player{} = player, ind, %Grid{} = board) do
    marker = maybe_randomize_marker(player)
    Board.place_marker(board, ind, marker)
  end

  defp maybe_randomize_marker(player) do
    if :rand.uniform() <= @chance_of_other_marker,
      do: other_marker(player.marker),
      else: player.marker
  end

  defp other_marker(:o), do: :x
  defp other_marker(:x), do: :o

  @doc """
  Checks if end-game state has been reached on the board
  """
  def check_end_game_conditions(%Grid{} = board) do
    win_result = check_for_winner(paths(), board.tiles)
    board_full? = check_board_full(board.tiles)

    cond do
      win_result in [:player_one_win, :player_two_win] -> win_result
      board_full? -> :draw
      true -> :continue
    end
  end

  defp paths,
    do: [
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]

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
