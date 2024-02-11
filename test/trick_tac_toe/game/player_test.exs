defmodule TrickTacToe.Game.PlayerTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game.Player

  describe "new/2" do
    test "returns error if name is not a string" do
      assert {:error, "name must be a string"} = Player.new(:atom, 2)
    end

    test "returns error if name is empty string" do
      assert {:error, "name cannot be empty"} = Player.new("", 1)
    end

    test "returns error if given invalid player number" do
      assert {:error, "invalid player number"} = Player.new("Guy Laroche", 12)
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
end
