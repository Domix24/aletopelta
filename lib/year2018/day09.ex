defmodule Aletopelta.Year2018.Day09 do
  @moduledoc """
  Day 9 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())
    @type param() :: %{players: integer(), score: integer()}

    @spec parse_input(input()) :: param()
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        [player, score] =
          ~r"\d+"
          |> Regex.scan(line)
          |> Enum.flat_map(fn [number] -> [String.to_integer(number)] end)

        %{players: player, score: score}
      end)
      |> Enum.at(0)
    end

    @spec find(param()) :: integer()
    def find(%{players: players, score: last_marble}),
      do:
        {[], 0, []}
        |> solve(%{}, 1, last_marble, players)
        |> Map.values()
        |> Enum.max()

    defp solve(_, scores, marble, last_marble, _) when marble > last_marble, do: scores

    defp solve(zipper, scores, marble, last_marble, players) do
      player = rem(marble - 1, players) + 1

      {new_zipper, new_scores} =
        if rem(marble, 23) == 0 do
          {new_zipper, removed_value} = remove(zipper, -7)
          score = marble + removed_value
          new_scores = Map.update(scores, player, score, &(&1 + score))

          {new_zipper, new_scores}
        else
          new_zipper = insert(zipper, marble, 2)

          {new_zipper, scores}
        end

      solve(new_zipper, new_scores, marble + 1, last_marble, players)
    end

    defp insert({left, current, right}, value, n) do
      {new_left, new_current, new_right} = move({left, current, right}, n)
      {new_left, value, [new_current | new_right]}
    end

    defp remove({left, current, right}, n) do
      {new_left, target, new_right} = move({left, current, right}, n)

      case new_right do
        [next | rest] ->
          {{new_left, next, rest}, target}

        [] ->
          case new_left do
            [next | rest] -> {{rest, next, []}, target}
            [] -> {{[], 0, []}, target}
          end
      end
    end

    defp move(zipper, 0), do: zipper
    defp move({[], _, []} = zipper, _), do: zipper
    defp move({left, current, []}, n) when n > 0, do: move({[], current, Enum.reverse(left)}, n)

    defp move({left, current, [next | rest]}, n) when n > 0,
      do: move({[current | left], next, rest}, n - 1)

    defp move({[], current, right}, n) when n < 0, do: move({Enum.reverse(right), current, []}, n)

    defp move({[prev | rest], current, right}, n) when n < 0,
      do: move({rest, prev, [current | right]}, n + 1)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> then(fn param -> Map.put(param, :score, param.score * 100) end)
      |> Common.find()
    end
  end
end
