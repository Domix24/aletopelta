defmodule AletopeltaTest.Year2017.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6681
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2392
  end
end
