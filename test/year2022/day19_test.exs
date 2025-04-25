defmodule AletopeltaTest.Year2022.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1150
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 37_367
  end
end
