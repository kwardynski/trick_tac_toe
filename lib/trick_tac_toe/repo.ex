defmodule TrickTacToe.Repo do
  use Ecto.Repo,
    otp_app: :trick_tac_toe,
    adapter: Ecto.Adapters.Postgres
end
