defmodule AletopeltaTest.Year2024.Day19 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day19, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 209
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 777_669_668_613_191
  end
end
