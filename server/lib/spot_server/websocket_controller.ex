defmodule SpotServer.WebsocketController do
  @moduledoc false
  @behaviour :cowboy_websocket

  require Logger

  @impl :cowboy_websocket
  def init(req, _state) do
    state = %{
      room: nil,
      turn_token_expiry: 0
    }

    {:cowboy_websocket, req, state, %{idle_timeout: :timer.seconds(30)}}
  end

  @impl :cowboy_websocket
  def websocket_init(state) do
    :timer.send_interval(:timer.seconds(5), :send_ping)
    {:ok, state}
  end

  def websocket_handle({:text, "ping"}, state) do
    Logger.info("Received a ping, responding a pong!")
    {:reply, {:text, "pong"}, state}
  end

  def websocket_handle({:ping, _message}, state) do
    Logger.info("Received a ping, responding a pong!")
    {:reply, {:text, "pong"}, state}
  end

  def websocket_handle({:pong, _message}, state) do
    Logger.info("Received pong from client!")
    {:reply, {:pong, "pong"}, state}
  end


  @impl :cowboy_websocket
  def websocket_info(:send_ping, state) do
    Logger.info("Sending a ping")
    {:reply, {:ping, "server_ping"}, state}
  end

  @impl :cowboy_websocket
  def websocket_info(message, state) do
    Logger.warn("Unknown info message: #{inspect(message)}")
    {:ok, state}
  end

  @impl :cowboy_websocket
  def websocket_handle(message, state) do
    Logger.warn("Unknown handle message: #{inspect(message)}")
    {:ok, state}
  end

end