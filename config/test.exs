import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :trick_tac_toe, TrickTacToe.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "trick_tac_toe_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trick_tac_toe, TrickTacToeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "z94E1Z7UvnEI3hLYc7ume/yQ8PFc6Z1tPum94dWNI5ORyV+eDs8Y9u8dfE4ZHb6z",
  server: false

# In test we don't send emails.
config :trick_tac_toe, TrickTacToe.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
