defmodule SpotServer.MessageChecker do
  @room_events [
    :leave_room,
    :join_room,
    :update_status,
    :send_to_peer,
    :add_user_to_call
  ]
  def check(%{"event" => event} = message, room) do
    with message = fill_optional(message),
         :ok <- check_completeness(message),
         :ok <- check_room_event(room, String.to_atom(event)),
         do: {:ok, message}
  end

  defp fill_optional(message) do
    if(message["event"] == "join_room" && !message["status"]) do
      Map.put(message, "status", %{})
    else
      message
    end
  end

  defp check_completeness(message = %{"event" => event}) do
    if complete?(event, message),
      do: :ok,
      else: {:error, "Unkown event name."}
  end

  defp complete?("join_room", message) do
    is_binary(message["room_id"]) && is_map(message["status"])
  end

  defp complete?("send_to_peer", message),
    do: is_binary(message["peer_id"]) && is_map(message["data"])

  defp complete?("update_status", message), do: is_map(message["status"])
  defp complete?("leave_room", message), do: true
  defp complete?("ping", _message), do: true
  defp complete?(_, _), do: false

  defp check_room_event(room, event) do
    if room || !Enum.member?(@room_events, event) do
      if valid_room_event(room, event) do
        :ok
      else
        {:error, "Can only join one roon with one session."}
      end
    else
      {:error, "This action is possible when user is in a room."}
    end
  end

  defp valid_room_event(room, "join_room") when not is_nil(room), do: false
  defp valid_room_event(_room, _event), do: true
end
