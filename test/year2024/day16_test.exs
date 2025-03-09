defmodule AletopeltaTest.Year2024.Day16 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 85_432
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 465
  end
end
