defmodule AletopeltaTest.Year2018.Day01 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day01, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 442
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 59_908
  end
end
