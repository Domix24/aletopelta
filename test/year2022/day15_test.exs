defmodule AletopeltaTest.Year2022.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4_876_693
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 11_645_454_855_041
  end
end
