defmodule TrickTacToe.GameTest do
  use ExUnit.Case, async: true

  alias TrickTacToe.Game

  setup do
    [game: Game.new()]
  end

  describe "Placing a marker" do
    test "successfully places a marker", %{game: game} do
      {:reply, :ok, %{board: board}} = Game.handle_call({:place_marker, 0}, [], game)
      %{tiles: %{0 => %{attributes: %{marker: marker}}}} = board
      refute is_nil(marker)
    end

    test "has a chance of placing the other player's marker", %{game: game} do
      markers =
        for _ <- 1..100 do
          {:reply, :ok, game} = Game.handle_call({:place_marker, 0}, [], game)

          game
          |> Map.get(:board)
          |> Map.get(:tiles)
          |> Map.get(0)
          |> Map.get(:attributes)
          |> Map.get(:marker)
        end

      assert Enum.any?(markers, &(&1 == :o))
    end
  end
end
