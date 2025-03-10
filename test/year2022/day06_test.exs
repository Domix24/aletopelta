defmodule AletopeltaTest.Year2022.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1140
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3495
  end
end
