defmodule AletopeltaTest.Year2019.Day23 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day23, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 16_685
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 11_048
  end
end
