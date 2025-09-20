defmodule AletopeltaTest.Year2018.Day07 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2018.Day07, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "HEGMPOAWBFCDITVXYZRKUQNSLJ"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1226
  end
end
