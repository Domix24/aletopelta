defmodule AletopeltaTest.Year2025.Day08 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 57_564
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 133_296_744
  end
end
