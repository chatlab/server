defmodule SpotServer.SocketAcceptor do
  require Logger

  @behaviour :cowboy_websocket_handler
  @sub_type "subscribe"
  @pub_type "publish"

  def init(req, opts), do: {:cowboy_websocket, req, opts}

  # Called on websocket connection initialization.
  def websocket_init(_type, req, opts) do
    timeout = Keyword.get(opts, :timeout)
    registry_key = Keyword.get(opts, :registry_key)
    state = %{registry_key: registry_key}
    # This is a good place to negotiate protocols, authenticate etc.
    {:ok, req, state, timeout}
  end

  # Respond to ping
  def websocket_handle({:text, "ping"}, state) do
    {:reply, {:text, "pong"}, state}
  end

  # Handle messages from client, either we subscribe, or publish.
  # The result is a nack or ack depending on outcome.
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

  # Messages received through the info callback are from
  # other elixir processes, for instance when a publish
  # is performed on a topic this process subscribes on
  # we send the messge to the client
  def websocket_info({:broadcast, message}, state) do
    Logger.info("Socket info: ")
    Logger.info(message, state)
    {:reply, {:text, message}, state}
  end

  # No matter why we terminate, remove all of this pids subscriptions
  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
