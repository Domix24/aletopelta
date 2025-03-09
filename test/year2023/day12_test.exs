defmodule AletopeltaTest.Year2023.Day12 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day12, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7705
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 50_338_344_809_230
  end
end
