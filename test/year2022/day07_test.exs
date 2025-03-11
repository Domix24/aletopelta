defmodule AletopeltaTest.Year2022.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_477_771
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_579_501
  end
end
