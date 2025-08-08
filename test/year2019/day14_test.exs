defmodule AletopeltaTest.Year2019.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 399_063
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 4_215_654
  end
end
