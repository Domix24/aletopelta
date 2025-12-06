defmodule AletopeltaTest.Year2025.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1467
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 8484
  end
end
