defmodule AletopeltaTest.Year2021.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 741
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2976
  end
end
