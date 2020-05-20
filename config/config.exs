# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :delivery_center,
  ecto_repos: [DeliveryCenter.Repo]

# Configures the endpoint
config :delivery_center, DeliveryCenterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ogsaDi+kM3xs24c5mQLNK6j4zi2pRCnbJVmBAjqylUARu66h13DQ1u9ZDvheF1s8",
  render_errors: [view: DeliveryCenterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: DeliveryCenter.PubSub,
  live_view: [signing_salt: "P6CHFQuj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
