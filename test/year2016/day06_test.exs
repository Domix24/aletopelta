defmodule AletopeltaTest.Year2016.Day06 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2016.Day06, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "agmwzecr"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "owlaxqvq"
  end
end
