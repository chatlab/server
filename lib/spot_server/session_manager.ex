defmodule SpotServer.SessionManager do
  require Logger

  def init() do
    self()
    |> inspect()
    |> Base.encode32(case: :lower)
    |> then(&("USER_" <> &1))
    |> String.to_atom()
    |> then(&Process.register(self(), &1))
  end

  def handle_message(message, state) do
    Logger.info("Handling event: " <> message["event"])

    # Update event to a atom
    message = %{message | "event" => String.to_atom(message["event"])}

    case SpotServer.MessageChecker.check(message, state) do
      {:ok, message} ->
        apply(__MODULE__, String.to_existing_atom("event_" <> message["event"]), [message, state])

      {:error, error} ->
        send_error(error, message)
    end
  end

  def event_join_room(message, state) do
    Logger.info("SessionManager: join_room event")
  end

  def event_ping(message, state) do
    Logger.info("SessionManager: ping event")
  end

  defp send_error(error, recived_message) do
    send(
      self(),
      {:to_user,
       %{
         event: "error",
         description: error,
         received_msg: recived_message
       }}
    )
  end
end
