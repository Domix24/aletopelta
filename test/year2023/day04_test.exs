defmodule AletopeltaTest.Year2023.Day04 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 24_160
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 5_659_035
  end
end
