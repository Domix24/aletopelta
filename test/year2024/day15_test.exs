defmodule AletopeltaTest.Year2024.Day15 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day15, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 1_495_147
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_524_905
  end
end
