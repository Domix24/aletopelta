defmodule AletopeltaTest.Year2017.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3969
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 917
  end
end
