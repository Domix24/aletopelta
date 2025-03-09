defmodule AletopeltaTest.Year2023.Day03 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day03, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 539_713
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 84_159_075
  end
end
