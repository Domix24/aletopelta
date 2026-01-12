defmodule AletopeltaTest.Year2016.Day25 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day25, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 196
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
