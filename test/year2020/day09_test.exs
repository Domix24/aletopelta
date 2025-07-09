defmodule AletopeltaTest.Year2020.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 552_655_238
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 70_672_245
  end
end
