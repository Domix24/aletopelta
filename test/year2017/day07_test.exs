defmodule AletopeltaTest.Year2017.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "rqwgj"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 333
  end
end
