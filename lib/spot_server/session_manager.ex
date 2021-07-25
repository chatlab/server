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
    incoming_message(message, state)
  end

  defp incoming_message(message = %{"event" => "join_room"}, state) do
    Logger.info("SessionManager: join_room event")
  end

  defp incoming_message(%{"event" => "ping"}, state) do
    send(self(), {:to_user, %{event: "pong"}})
    state
  end
end
