defmodule Aletopelta.Year2021.Day20 do
  @moduledoc """
  Day 20 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: [binary()]
    @type output() :: {algorithm(), image()}
    @type algorithm() :: %{integer() => 0 | 1}
    @type image() :: %{{integer(), integer()} => 0 | 1}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      [[algorithm] | image] =
        input
        |> Enum.chunk_by(&(&1 == ""))
        |> Enum.reject(&(&1 == [""]))

      {parse_algorithm(algorithm), parse_image(image)}
    end

    defp parse_algorithm(algorithm) do
      algorithm
      |> parse_algorithm(0)
      |> Map.new()
    end

    defp parse_algorithm("", _), do: []

    defp parse_algorithm(<<".", rest::binary>>, idx),
      do: [{idx, 0} | parse_algorithm(rest, idx + 1)]

    defp parse_algorithm(<<"#", rest::binary>>, idx),
      do: [{idx, 1} | parse_algorithm(rest, idx + 1)]

    defp parse_image([image]) do
      image
      |> Enum.reduce({0, []}, fn line, {y, acc_list} ->
        new_acc = parse_line(line, 0, y) ++ acc_list
        {y + 1, new_acc}
      end)
      |> elem(1)
      |> Map.new()
    end

    defp parse_line("", _, _), do: []
    defp parse_line(<<".", rest::binary>>, x, y), do: [{{x, y}, 0} | parse_line(rest, x + 1, y)]
    defp parse_line(<<"#", rest::binary>>, x, y), do: [{{x, y}, 1} | parse_line(rest, x + 1, y)]

    @spec prepare_enhance(output(), integer()) :: image()
    def prepare_enhance({algorithm, image}, times),
      do:
        {algorithm, image, {0, Map.fetch!(algorithm, 0) == 1}}
        |> Stream.iterate(&prepare_iterate/1)
        |> Stream.take(times + 1)
        |> Stream.take(-1)
        |> Enum.at(0)
        |> elem(1)

    defp prepare_iterate({algorithm, image, {index, fill?}}),
      do: iterate_image({algorithm, image, {rem(index + 1, 2), fill?}})

    defp iterate_image({algorithm, image, void}),
      do:
        image
        |> enhance_image(algorithm, void, MapSet.new())
        |> iterate_image(algorithm, void)

    defp iterate_image(image, algorithm, void), do: {algorithm, image, void}

    defp enhance_image(image, algorithm, void, visited),
      do:
        image
        |> Map.keys()
        |> enhance_image(image, algorithm, void, visited)
        |> Map.new()

    defp enhance_image([current | others], image, algorithm, void, visited),
      do:
        current
        |> get_neighbors()
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> Enum.flat_map(&enhance_neighbor(&1, image, algorithm, void))
        |> prepare_continue(others, image, algorithm, void, visited)

    defp get_neighbors({x, y}),
      do: [
        {x - 1, y - 1},
        {x, y - 1},
        {x + 1, y - 1},
        {x - 1, y},
        {x, y},
        {x + 1, y},
        {x - 1, y + 1},
        {x, y + 1},
        {x + 1, y + 1}
      ]

    defp enhance_neighbor(neighbor, image, algorithm, void),
      do:
        neighbor
        |> get_neighbors()
        |> Enum.map_join(&Map.get(image, &1, get_pixel(void)))
        |> String.to_integer(2)
        |> get_enhance(algorithm)
        |> continue_neighbor(neighbor)

    defp get_pixel({_, false}), do: 0
    defp get_pixel({i, true}), do: rem(i + 1, 2)

    defp get_enhance(binary, algorithm), do: Map.fetch!(algorithm, binary)
    defp continue_neighbor(enhanced, neighbor), do: [{neighbor, enhanced}]

    defp prepare_continue(current, others, image, algorithm, void, visited),
      do:
        current
        |> MapSet.new(&elem(&1, 0))
        |> MapSet.union(visited)
        |> continue_image(current, others, image, algorithm, void)

    defp continue_image(_, current, [], _, _, _), do: current

    defp continue_image(visited, current, others, image, algorithm, void),
      do: current ++ enhance_image(others, image, algorithm, void, visited)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_enhance(2)
      |> Enum.sum_by(&elem(&1, 1))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_enhance(50)
      |> Enum.sum_by(&elem(&1, 1))
    end
  end
end
