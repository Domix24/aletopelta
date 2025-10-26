defmodule AletopeltaTest.Year2018.Day20 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3839
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 8407
  end
end
