defmodule AletopeltaTest.Year2019.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7_566_643
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 9_265_694
  end
end
