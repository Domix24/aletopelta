defmodule AletopeltaTest.Year2021.Day13 do
  use ExUnit.Case, async: true
  alias Aletopelta.Year2021.Day13, as: Solution

  test "is part1 working" do
    assert Belodon.solve(Solution, :part1) == 684
  end

  test "is part2 working" do
    assert Belodon.solve(Solution, :part2) == [
             "..##.###..####.###..#.....##..#..#.#..#",
             "...#.#..#....#.#..#.#....#..#.#.#..#..#",
             "...#.#..#...#..###..#....#....##...####",
             "...#.###...#...#..#.#....#.##.#.#..#..#",
             "#..#.#.#..#....#..#.#....#..#.#.#..#..#",
             ".##..#..#.####.###..####..###.#..#.#..#"
           ]
  end
end
