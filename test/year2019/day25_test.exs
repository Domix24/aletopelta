defmodule AletopeltaTest.Year2019.Day25 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day25, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2_155_873_288
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 0
  end
end
