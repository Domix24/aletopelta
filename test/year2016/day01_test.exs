defmodule AletopeltaTest.Year2016.Day01 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 230
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 154
  end
end
