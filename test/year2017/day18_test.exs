defmodule AletopeltaTest.Year2017.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7071
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 8001
  end
end
