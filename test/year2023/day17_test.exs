defmodule AletopeltaTest.Year2023.Day17 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day17, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 843
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1017
  end
end
