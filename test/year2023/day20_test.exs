defmodule AletopeltaTest.Year2023.Day20 do
  use ExUnit.Case
  alias Aletopelta.Year2023.Day20, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 681_194_780
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == 238_593_356_738_827
  end
end
