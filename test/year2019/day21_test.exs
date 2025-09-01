defmodule AletopeltaTest.Year2019.Day21 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day21, as: Solution

  @moduletag timeout: :infinity
  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 19_355_436
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 1_142_618_405
  end
end
