defmodule AletopeltaTest.Year2015.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 307
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 160
  end
end
