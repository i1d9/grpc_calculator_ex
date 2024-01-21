defmodule AbacistTest do
  use ExUnit.Case
  doctest Abacist

  test "greets the world" do
    assert Abacist.hello() == :world
  end
end
