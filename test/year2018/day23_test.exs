defmodule AletopeltaTest.Year2018.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 430
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 80_250_793
  end
end
