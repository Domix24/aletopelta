defmodule AletopeltaTest.Year2024.Day08 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 371
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1229
  end
end
