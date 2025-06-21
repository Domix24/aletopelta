defmodule AletopeltaTest.Year2021.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 323
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 10_685
  end
end
