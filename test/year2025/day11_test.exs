defmodule AletopeltaTest.Year2025.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 796
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 294_053_029_111_296
  end
end
