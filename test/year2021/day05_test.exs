defmodule AletopeltaTest.Year2021.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7473
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 24_164
  end
end
