defmodule AletopeltaTest.Year2016.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1951
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 20_002_936
  end
end
