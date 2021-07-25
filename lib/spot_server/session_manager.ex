defmodule SpotServer.SessionManager do
    def init() do
      self()
      |> inspect()
      |> Base.encode32(case: :lower)
      |> then(&"user_" <> &1)
      |> String.to_atom()
      |> then(&Process.register(self(), &1))
    end

    def handle_message(message, state) do

    end
end
