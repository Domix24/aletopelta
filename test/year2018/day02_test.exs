defmodule AletopeltaTest.Year2018.Day02 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day02, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 7410
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "cnjxoritzhvbosyewrmqhgkul"
  end
end
