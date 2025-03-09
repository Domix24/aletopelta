defmodule AletopeltaTest.Year2022.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7742
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2276
  end
end
