defmodule AletopeltaTest.Year2021.Day09 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day09, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 548
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 786_048
  end
end
