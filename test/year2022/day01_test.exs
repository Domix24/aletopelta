defmodule AletopeltaTest.Year2022.Day01 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 71_934
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 211_447
  end
end
