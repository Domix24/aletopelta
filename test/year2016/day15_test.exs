defmodule AletopeltaTest.Year2016.Day15 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 121_834
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 3_208_099
  end
end
