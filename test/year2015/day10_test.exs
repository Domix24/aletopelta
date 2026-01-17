defmodule AletopeltaTest.Year2015.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2015.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 492_982
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 6_989_950
  end
end
