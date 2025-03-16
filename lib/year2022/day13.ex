defmodule Aletopelta.Year2022.Day13 do
  @moduledoc """
  Day 13 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """
    @spec parse_input(list()) :: list()
    def parse_input(input) do
      input
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&elem(Code.eval_string(&1), 0))
    end

    @spec compare_packets(list()) :: :ko | :ok | true
    def compare_packets([first, second]), do: compare_packets(first, second)

    @spec compare_packets(any(), any()) :: :ko | :ok | true
    def compare_packets([[] | rest_packet1], [[] | rest_packet2]),
      do: compare_packets(rest_packet1, rest_packet2)

    def compare_packets([], []), do: true

    def compare_packets([], _), do: :ok
    def compare_packets(_, []), do: :ko

    def compare_packets([[] | _], [_ | _]), do: :ok
    def compare_packets([_ | _], [[] | _]), do: :ko

    def compare_packets([head_packet1 | _], [head_packet2 | _])
        when is_integer(head_packet1) and is_integer(head_packet2) and head_packet1 < head_packet2,
        do: :ok

    def compare_packets([head_packet1 | _], [head_packet2 | _])
        when is_integer(head_packet1) and is_integer(head_packet2) and head_packet1 > head_packet2,
        do: :ko

    def compare_packets([head_packet1 | rest_packet1], [head_packet2 | rest_packet2])
        when is_integer(head_packet1) and is_integer(head_packet2) and
               head_packet1 == head_packet2,
        do: compare_packets(rest_packet1, rest_packet2)

    def compare_packets([[_ | _] = head_packet1 | rest_packet1], [
          [_ | _] = head_packet2 | rest_packet2
        ]) do
      case compare_packets(head_packet1, head_packet2) do
        true -> compare_packets(rest_packet1, rest_packet2)
        term -> term
      end
    end

    def compare_packets([head_packet1 | rest_packet1], [[_ | _] = head_packet2 | rest_packet2]),
      do: compare_packets([[head_packet1] | rest_packet1], [head_packet2 | rest_packet2])

    def compare_packets([[_ | _] = head_packet1 | rest_packet1], [head_packet2 | rest_packet2]),
      do: compare_packets([head_packet1 | rest_packet1], [[head_packet2] | rest_packet2])
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.chunk_every(2)
      |> do_compare(1)
      |> Enum.sum()
    end

    defp do_compare([], _), do: []

    defp do_compare([first | next], indice) do
      if Common.compare_packets(first) != :ko do
        [indice | do_compare(next, indice + 1)]
      else
        do_compare(next, indice + 1)
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(list()) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> List.insert_at(0, [[2]])
      |> List.insert_at(0, [[6]])
      |> Enum.sort_by(& &1, &do_compare/2)
      |> Enum.with_index(1)
      |> Enum.filter(&delimiter?/1)
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(&(&1 * &2))
    end

    defp do_compare(packet1, packet2) do
      Common.compare_packets([packet1, packet2]) != :ko
    end

    defp delimiter?({[[2]], _}), do: true
    defp delimiter?({[[6]], _}), do: true
    defp delimiter?({_, _}), do: false
  end
end
