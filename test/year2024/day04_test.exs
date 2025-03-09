defmodule AletopeltaTest.Year2024.Day04 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2562
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1902
  end
end
