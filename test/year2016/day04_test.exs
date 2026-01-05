defmodule AletopeltaTest.Year2016.Day04 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day04, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 361_724
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 482
  end
end
