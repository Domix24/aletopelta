defmodule AletopeltaTest.Year2025.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4_774_877_510
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_560_475_800
  end
end
