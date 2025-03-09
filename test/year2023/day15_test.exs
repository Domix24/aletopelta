defmodule AletopeltaTest.Year2023.Day15 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 502_139
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 284_132
  end
end
