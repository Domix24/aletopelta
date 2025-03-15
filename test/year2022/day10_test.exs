defmodule AletopeltaTest.Year2022.Day10 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2022.Day10, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 14_760
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == [
             "####.####..##..####.###..#..#.###..####.",
             "#....#....#..#.#....#..#.#..#.#..#.#....",
             "###..###..#....###..#..#.#..#.#..#.###..",
             "#....#....#.##.#....###..#..#.###..#....",
             "#....#....#..#.#....#.#..#..#.#.#..#....",
             "####.#.....###.####.#..#..##..#..#.####."
           ]
  end
end
