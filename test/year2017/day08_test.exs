defmodule AletopeltaTest.Year2017.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4416
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 5199
  end
end
