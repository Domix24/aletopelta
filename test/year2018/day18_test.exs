defmodule AletopeltaTest.Year2018.Day18 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day18, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 511_000
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 194_934
  end
end
