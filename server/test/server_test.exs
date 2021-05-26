defmodule SpotServerTest do
  use ExUnit.Case
  doctest SpotServer

  test "greets the world" do
    assert SpotServer.hello() == :world
  end
end
