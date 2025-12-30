defmodule AletopeltaTest.Year2017.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2017.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 8536
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "aff593797989d665349efe11bb4fd99b"
  end
end
