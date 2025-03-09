defmodule AletopeltaTest.Year2024.Day21 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day21, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 179_444
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 223_285_811_665_866
  end
end
