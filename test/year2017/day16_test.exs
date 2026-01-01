defmodule AletopeltaTest.Year2017.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == "pkgnhomelfdibjac"
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "pogbjfihclkemadn"
  end
end
