defmodule AletopeltaTest.Year2024.Day02 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 341
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 404
  end
end
