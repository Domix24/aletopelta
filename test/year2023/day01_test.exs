defmodule AletopeltaTest.Year2023.Day01 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 54_450
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 54_265
  end
end
