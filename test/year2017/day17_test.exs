defmodule AletopeltaTest.Year2017.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1914
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 41_797_835
  end
end
