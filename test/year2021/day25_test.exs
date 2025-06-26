defmodule AletopeltaTest.Year2021.Day25 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day25, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 374
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
