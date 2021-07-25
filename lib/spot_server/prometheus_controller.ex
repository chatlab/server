defmodule SpotServer.PrometheusController do
  @moduledoc false
  @behaviour :cowboy_handler

  @impl :cowboy_handler
  def init(request, _state) do
    {:ok, request, :no_state}
  end

  @impl :cowboy_handler
  def terminate(_reason, _request, _state), do: :ok
end
