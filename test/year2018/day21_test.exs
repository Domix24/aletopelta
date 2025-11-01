defmodule AletopeltaTest.Year2018.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6_132_825
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 8_307_757
  end
end
