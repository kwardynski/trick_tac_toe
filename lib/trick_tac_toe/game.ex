defmodule TrickTacToe.Game do
  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player
  alias TrickTacToe.Game.States

  defstruct [:board, :players, :state]

  @chance_of_other_marker 0.20

  @doc """
  Initializes a new game
  """
  def new() do
    %__MODULE__{
      players: %{
        player_one: Player.new("Player One", 1),
        player_two: Player.new("Player Two", 2)
      },
      board: Board.initialize_board(),
      state: States.initial_state()
    }
  end

  @doc """
  Handles the transition of a game's state
  """
  def transition_state(game, event) do
    next_state = States.transition(game.state, event)
    %{game | state: next_state}
  end

  @doc """
  Places a marker on the board for a player
  """
  def place_marker(%__MODULE__{} = game, ind) do
    marker = determine_marker(game)
    board = Board.place_marker(game.board, ind, marker)
    %{game | board: board}
  end

  defp determine_marker(%{state: :player_one_turn}), do: maybe_randomize_marker(:x)
  defp determine_marker(%{state: :player_two_turn}), do: maybe_randomize_marker(:o)

  defp maybe_randomize_marker(marker) do
    if :rand.uniform() <= @chance_of_other_marker,
      do: other_marker(marker),
      else: marker
  end

  defp other_marker(:o), do: :x
  defp other_marker(:x), do: :o

  @doc """
  Checks if end-game state has been reached on the board
  """
  def check_end_game_conditions(%__MODULE__{} = game) do
    %{board: %{tiles: tiles}} = game

    win_result = check_for_winner(paths(), tiles)
    board_full? = check_board_full(tiles)

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
