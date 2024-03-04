defmodule TrickTacToe.Game.States do
  def initial_state, do: :player_one_turn

  def transition(:player_one_turn, :continue), do: {:ok, :player_two_turn}
  def transition(:player_two_turn, :continue), do: {:ok, :player_one_turn}

  def transition(_, :draw), do: {:ok, :end_game}
  def transition(_, :player_one_win), do: {:ok, :player_one_win}
  def transition(_, :player_two_win), do: {:ok, :player_two_win}

  def transition(:end_game, :new_game), do: {:ok, :player_one_turn}

  def transition(_, _), do: {:error, :unknown_state}
end
