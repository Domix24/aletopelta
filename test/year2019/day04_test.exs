defmodule AletopeltaTest.Year2019.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1330
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 876
  end
end
