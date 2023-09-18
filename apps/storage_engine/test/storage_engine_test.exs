defmodule StorageEngineTest do
  use ExUnit.Case
  doctest StorageEngine

  test "greets the world" do
    assert StorageEngine.hello() == :world
  end
end
