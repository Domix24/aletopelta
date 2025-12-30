defmodule AletopeltaTest.Year2017.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 834
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1569
  end
end
