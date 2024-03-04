defmodule TrickTacToe.Game do
  use GenServer

  alias GamesEngine.Grid

  alias TrickTacToe.Game.Board
  alias TrickTacToe.Game.Player
  alias TrickTacToe.Game.States

  defstruct [:board, :player_one, :player_two, :state]

  @chance_of_other_marker 0.20

  def new() do
    %__MODULE__{
      player_one: Player.new("Player One", 1),
      player_two: Player.new("Player Two", 2),
      board: Board.initialize_board(),
      state: States.initial_state()
    }
  end

  def start_link(:ok) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def place_marker(pid, ind) do
    GenServer.call(pid, {:place_marker, ind})
  end

  @impl true
  def init(:ok) do
    {:ok, new()}
  end

  @impl true
  def handle_call({:place_marker, ind}, _from, game) do
    with(
      :ok <- verify_player_turn(game),
      {:ok, marker} <- determine_marker(game),
      %Grid{} = board <- Board.place_marker(game.board, ind, marker),
      {:ok, result} <- Board.check_end_game_conditions(board),
      {:ok, next_state} <- States.transition(game.state, result)
    ) do
      game = %{game | board: board, state: next_state}
      {:reply, next_state, game}
    else
      error -> {:reply, error, game}
    end
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
end
