defmodule AletopeltaTest.Year2024.Day22 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 19_877_757_850
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 2399
  end
end
