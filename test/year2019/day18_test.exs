defmodule AletopeltaTest.Year2019.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 5450
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2020
  end
end
