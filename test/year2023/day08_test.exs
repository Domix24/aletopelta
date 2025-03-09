defmodule AletopeltaTest.Year2023.Day08 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day08, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 16_343
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 15_299_095_336_639
  end
end
