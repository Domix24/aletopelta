defmodule AletopeltaTest.Year2023.Day06 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_159_152
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 41_513_103
  end
end
