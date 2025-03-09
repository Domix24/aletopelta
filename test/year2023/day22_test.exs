defmodule AletopeltaTest.Year2023.Day22 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 477
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 61_555
  end
end
