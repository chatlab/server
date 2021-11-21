defmodule SpotServer do
  use Application
  require Logger

  @impl Application
  def start(_type, _args) do
    configure_cowboy()
    |> start_supervisor()
  end

  defp start_supervisor({host, port, dispatch}) do
    childrens = [
      #      {DynamicSupervisor, name: SpotServer.Room.Supervisor, strategy: :one_for_one},
      #      {SpotServer.Stats, []},
      %{
        id: :cowboy,
        start:
          {:cowboy, :start_clear, [:http, [ip: host, port: port], %{env: %{dispatch: dispatch}}]}
      }
    ]

    status = childrens |> Supervisor.start_link(strategy: :one_for_one)
    Logger.info("Spot server started...")
    status
  end

  defp configure_cowboy() do
    host = Application.get_env(:spot_server, :host, {127, 0, 0, 1})
    port = Application.get_env(:spot_server, :port, 4333)
    {host, port, dispatch()}
  end

  defp dispatch() do
    :cowboy_router.compile([
      {"localhost",
       [
         {"/", SpotServer.WebsocketController, []}
       ]},
      {:_, [{"/", SpotServer.WebsocketController, []}]}
    ])
  end
end
