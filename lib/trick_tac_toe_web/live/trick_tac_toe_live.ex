defmodule TrickTacToeWeb.TrickTacToeLive do
  # add phx-click attribute to grid item
  # use phx-value-<value_name>="value" to pass ind to handle_event

  use TrickTacToeWeb, :live_view

  alias TrickTacToe.Game

  def mount(_params, _session, socket), do: {:ok, assign(socket, game: Game.new())}

  def render(assigns) do
    ~H"""
    <h1>Trick Tac Toe</h1>

    <div id="score-count">
      <h2><%= "Player 1: #{@game.player_one.wins} wins" %></h2>
      <h2><%= "Player 2: #{@game.player_two.wins} wins" %></h2>
    </div>

    <div id="game-state">
      <%= display_game_state(@game.state) %>
    </div>

    <div id="board" class="grid-container">
      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="0">
        <%= marker(@game.board.tiles[0].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="3">
        <%= marker(@game.board.tiles[3].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="6">
        <%= marker(@game.board.tiles[6].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="1">
        <%= marker(@game.board.tiles[1].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="4">
        <%= marker(@game.board.tiles[4].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="7">
        <%= marker(@game.board.tiles[7].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="2">
        <%= marker(@game.board.tiles[2].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="5">
        <%= marker(@game.board.tiles[5].attributes.marker) %>
      </div>

      <div class="grid-item" phx-click="tile-clicked" , phx-value-index="8">
        <%= marker(@game.board.tiles[8].attributes.marker) %>
      </div>
    </div>

    <button class="button" phx-click="new-game">New Game</button>
    """
  end

  def handle_event("tile-clicked", %{"index" => ind_string}, socket) do
    index = String.to_integer(ind_string)

    {_, game} = Game.place_marker(socket.assigns.game, index)
    {:noreply, assign(socket, game: game)}
  end

  def handle_event("new-game", _value, socket) do
    {:ok, game} = Game.reset_game(socket.assigns.game)
    {:noreply, assign(socket, game: game)}
  end

  defp display_game_state(:player_one_turn), do: "P1's turn, hopefully place an X"
  defp display_game_state(:player_two_turn), do: "P2's turn, hopefully place an O"
  defp display_game_state(:player_one_win), do: "P1 Wins!"
  defp display_game_state(:player_two_win), do: "P2 Wins!"
  defp display_game_state(:draw), do: "Draw!"

  defp marker(nil), do: " "
  defp marker(:x), do: "X"
  defp marker(:o), do: "O"
end
