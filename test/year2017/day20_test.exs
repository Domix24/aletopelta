defmodule AletopeltaTest.Year2017.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 364
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 420
  end
end
