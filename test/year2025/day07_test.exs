defmodule AletopeltaTest.Year2025.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1504
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 5_137_133_207_830
  end
end
