defmodule AletopeltaTest.Year2025.Day03 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 17_193
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 171_297_349_921_310
  end
end
