defmodule AletopeltaTest.Year2022.Day17 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 3149
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_553_982_300_884
  end
end
