defmodule AletopeltaTest.Year2020.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2020.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2344
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2076
  end
end
