defmodule AqlTest do
  use ExUnit.Case
  doctest Aql

  test "greets the world" do
    assert Aql.hello() == :world
  end
end
