defmodule AletopeltaTest.Year2021.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 5565
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2118
  end
end
