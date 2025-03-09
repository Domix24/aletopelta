defmodule AletopeltaTest.Year2023.Day21 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3788
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 631_357_596_621_921
  end
end
