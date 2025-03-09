defmodule AletopeltaTest.Year2024.Day24 do
  use ExUnit.Case
  alias Aletopelta.Year2024.Day24, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 55_114_892_239_566
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == "cdj,dhm,gfm,mrb,qjd,z08,z16,z32"
  end
end
