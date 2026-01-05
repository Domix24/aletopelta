defmodule AletopeltaTest.Year2016.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 110
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 242
  end
end
