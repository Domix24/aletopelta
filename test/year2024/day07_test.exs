defmodule AletopeltaTest.Year2024.Day07 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 267_566_105_056
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 116_094_961_956_019
  end
end
