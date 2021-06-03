defmodule SpotServer.SocketAcceptor do
  require Logger

  @behaviour :cowboy_websocket_handler
  @sub_type "subscribe"
  @pub_type "publish"

  @impl :cowboy_websocket
  def init(request, _state) do
    {:cowboy_websocket, request, _state}
  end

  @impl :cowboy_websocket
  def websocket_init(request, state, opts) do
    timeout = Keyword.get(opts, :timeout)
    registry_key = Keyword.get(opts, :registry_key)
    state = %{registry_key: registry_key}
    {:ok, request, state, timeout}
  end

  @impl :cowboy_websocket
  def websocket_handle({:text, "ping"}, state) do
    {:reply, {:text, "pong"}, state}
  end


  @impl :cowboy_websocket
  def websocket_handle({:text, content}, state) do
    registry_key = Keyword.get(state, :registry_key)
    content = Poison.decode!(content)

    %{"type" => type, "topic" => topic} = content

    response =
      case type do
        @sub_type ->
          SpotServer.PubSub.subscribe(topic, registry_key)
        @pub_type ->
          SpotServer.PubSub.publish({topic, Map.get(content, "payload")}, self(), registry_key)

        _ ->
          %{type: "nack"}
      end
      |> Poison.encode!()

    {:reply, {:text, response}, state}
  end

  @impl :cowboy_websocket
  def websocket_info({:broadcast, message}, state) do
    Logger.info("Socket info: ")
    Logger.info(message, state)
    {:reply, {:text, message}, state}
  end

  @impl :cowboy_websocket
  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
