defmodule AletopeltaTest.Year2025.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6_757_749_566_978
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 10_603_075_273_949
  end
end
