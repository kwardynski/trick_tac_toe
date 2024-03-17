defmodule TrickTacToe.Game do
  @moduledoc false

  alias GamesEngine.Grid

  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player
  alias TrickTacToe.Game.States

  defstruct [:board, :player_one, :player_two, :state]

  @chance_of_other_marker 0.20

  def new do
    %__MODULE__{
      player_one: Player.new("Player One", 1),
      player_two: Player.new("Player Two", 2),
      board: Board.initialize_board(),
      state: States.initial_state()
    }
  end

  def place_marker(game, ind) do
    with(
      :ok <- verify_player_turn(game),
      {:ok, marker} <- determine_marker(game),
      %Grid{} = board <- Board.place_marker(game.board, ind, marker),
      {:ok, result} <- Board.check_end_game_conditions(board),
      {:ok, next_state} <- States.transition(game.state, result)
    ) do
      game =
        game
        |> update_board(board)
        |> update_state(next_state)
        |> maybe_handle_win_condition(next_state)

      {:ok, game}
    else
      error -> {error, game}
    end
  end

  def reset_game(game) do
    game =
      game
      |> reset_board()
      |> reset_state()

    {:ok, game}
  end

  defp verify_player_turn(%{state: state}) when state in [:player_one_turn, :player_two_turn],
    do: :ok

  defp verify_player_turn(_game), do: {:error, :invalid_state}

  defp determine_marker(%{state: :player_one_turn}), do: {:ok, maybe_randomize_marker(:x)}
  defp determine_marker(%{state: :player_two_turn}), do: {:ok, maybe_randomize_marker(:o)}

  defp maybe_randomize_marker(marker) do
    if :rand.uniform() <= @chance_of_other_marker,
      do: other_marker(marker),
      else: marker
  end

  defp other_marker(:o), do: :x
  defp other_marker(:x), do: :o

  defp maybe_handle_win_condition(game, :player_one_win) do
    player_one = Player.add_win(game.player_one)
    %{game | player_one: player_one}
  end

  defp maybe_handle_win_condition(game, :player_two_win) do
    player_two = Player.add_win(game.player_two)
    %{game | player_two: player_two}
  end

  defp maybe_handle_win_condition(game, _), do: game

  defp update_board(game, board), do: %{game | board: board}
  defp update_state(game, state), do: %{game | state: state}

  defp reset_board(game), do: %{game | board: Board.initialize_board()}
  defp reset_state(game), do: %{game | state: States.initial_state()}
end
