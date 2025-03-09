defmodule AletopeltaTest.Year2024.Day05 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4662
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 5900
  end
end
