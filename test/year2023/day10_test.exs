defmodule AletopeltaTest.Year2023.Day10 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 6690
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 525
  end
end
