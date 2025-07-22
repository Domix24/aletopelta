defmodule AletopeltaTest.Year2020.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 68_781_323_018_729
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1629
  end
end
