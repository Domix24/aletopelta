defmodule AletopeltaTest.Year2022.Day14 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day14, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 838
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 27_539
  end
end
