defmodule SpotServer.MessageChecker do
  @room_events [
    :leave_room
  ]
  def check(%{"event" => event} = message, room) do
    :ok
  end
end
