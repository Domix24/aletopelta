defmodule AletopeltaTest.Year2024.Day11 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day11, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 186_175
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 220_566_831_337_810
  end
end
