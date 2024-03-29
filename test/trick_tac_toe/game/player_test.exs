defmodule TrickTacToe.Game.PlayerTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game.Player

  describe "new/2" do
    test "returns error if name is not a string" do
      assert {:error, :name_must_be_string} = Player.new(:atom, 2)
    end

    test "returns error if name is empty string" do
      assert {:error, :name_cannot_be_empty} = Player.new("", 1)
    end

    test "returns error if given invalid player number" do
      assert {:error, :invalid_player_number} = Player.new("Guy Laroche", 12)
    end

    test "creates a new player struct when given valid input" do
      assert %Player{
               name: "Guy Laroche",
               number: 1,
               marker: :x,
               wins: 0
             } = Player.new("Guy Laroche", 1)
    end
  end

  describe "add_win/1" do
    test "increments win attribute by 1" do
      assert %Player{wins: 1} =
               "Guy Laroche"
               |> Player.new(2)
               |> Player.add_win()
    end
  end
end
