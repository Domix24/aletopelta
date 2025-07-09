defmodule AletopeltaTest.Year2020.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1782
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 797
  end
end
