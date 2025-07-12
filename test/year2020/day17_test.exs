defmodule AletopeltaTest.Year2020.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 289
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2084
  end
end
