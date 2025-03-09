defmodule AletopeltaTest.Year2023.Day13 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 33_975
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 29_083
  end
end
