defmodule AletopeltaTest.Year2020.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 195
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 309
  end
end
