defmodule AletopeltaTest.Year2019.Day16 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2019.Day16, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 27_831_665
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 36_265_589
  end
end
