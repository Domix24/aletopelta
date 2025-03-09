defmodule AletopeltaTest.Year2022.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 9241
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 14_610
  end
end
