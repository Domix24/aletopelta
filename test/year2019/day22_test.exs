defmodule AletopeltaTest.Year2019.Day22 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day22, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 4485
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 91_967_327_971_097
  end
end
