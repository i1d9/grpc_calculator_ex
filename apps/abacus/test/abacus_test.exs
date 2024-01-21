defmodule AbacusTest do
  use ExUnit.Case
  doctest Abacus

  test "greets the world" do
    assert Abacus.hello() == :world
  end
end
