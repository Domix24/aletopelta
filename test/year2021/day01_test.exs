defmodule AletopeltaTest.Year2021.Day01 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1715
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1739
  end
end
