defmodule SpotServer.RoomManager do
  use GenServer, restart: :transient

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(room_id) do
    name = String.to_atom "ROOM_#{room_id}"
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def create(room_id) do
    case DynamicSupervisor.start_child(Supervisor, {__MODULE__, [room_id]}) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end


end
