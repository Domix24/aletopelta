defmodule AletopeltaTest.Year2016.Day05 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day05, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "4543c154"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "1050cbbd"
  end
end
