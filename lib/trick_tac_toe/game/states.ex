defmodule TrickTacToe.Game.States do
  def initial_state, do: :player_one_turn

  def transition(:player_one_turn, :continue), do: :player_two_turn
  def transition(:player_two_turn, :continue), do: :player_one_turn

  def transition(_, :draw), do: :end_game
  def transition(_, :player_one_win), do: :end_game
  def transition(_, :player_two_win), do: :end_game

  def transition(:end_game, :new_game), do: :player_one_turn

  def transition(_, _), do: {:error, :unknown_state}
end
