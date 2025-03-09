defmodule AletopeltaTest.Year2024.Day06 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4454
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1503
  end
end
