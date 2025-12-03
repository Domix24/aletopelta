defmodule AletopeltaTest.Year2025.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 31_839_939_622
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 41_662_374_059
  end
end
