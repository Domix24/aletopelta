defmodule AletopeltaTest.Year2017.Day19 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1, trim: false) == "XYFDJNRCQA"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2, trim: false) == 17_450
  end
end
