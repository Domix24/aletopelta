defmodule AletopeltaTest.Year2018.Day24 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 10_538
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 9174
  end
end
