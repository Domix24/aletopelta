defmodule AletopeltaTest.Year2018.Day11 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "235,14"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "237,227,14"
  end
end
