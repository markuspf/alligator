defmodule AlligatorTest do
  use ExUnit.Case
  doctest Alligator

  test "greets the world" do
    assert Alligator.hello() == :world
  end
end
