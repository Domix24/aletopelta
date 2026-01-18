defmodule AletopeltaTest.Year2015.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 814
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 924
  end
end
