defmodule AletopeltaTest.Year2018.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 399_645
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_352_507_536
  end
end
