defmodule AletopeltaTest.Year2021.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2541
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 4647
  end
end
