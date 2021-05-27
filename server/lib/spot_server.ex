defmodule SpotServer do
  use Application

  @registry_key :subscriptions

  def start(_type, _args) do
    import Supervisor.Spec

    port = Application.get_env(:spot_server, :port, 8888)
    timeout = Application.get_env(:spot_server, :timeout, 60000)
    ws_endpoint = Application.get_env(:spot_server, :ws_endpoint, "ws")

    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: SpotServer.Router,
        options: [
          port: port,
          dispatch: dispatch(ws_endpoint, timeout)
        ]
      ),
      supervisor(Registry, [:unique, @registry_key])
    ]

    opts = [strategy: :one_for_one, name: SpotServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch(endpoint, timeout) do
    [
      {:_,
       [
         {"/#{endpoint}", SpotServer.SocketAcceptor,
          [
            timeout: timeout,
            registry_key: @registry_key
          ]},
         {:_, Plug.Adapters.Cowboy.Handler, {SpotServer.Router, []}}
       ]}
    ]
  end
end
