# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :spot_server,
  port: 4444,
  timeout: 60000,
  ws_endpooint: "ws"
