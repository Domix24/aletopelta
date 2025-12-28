defmodule AletopeltaTest.Year2025.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2025.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 455
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 16_978
  end
end
