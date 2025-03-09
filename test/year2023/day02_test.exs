defmodule AletopeltaTest.Year2023.Day02 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 2278
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 67_953
  end
end
