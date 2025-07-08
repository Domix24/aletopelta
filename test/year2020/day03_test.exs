defmodule AletopeltaTest.Year2020.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 259
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2_224_913_600
  end
end
