defmodule Aletopelta.Year2022.Day02 do
  @moduledoc """
  Day 2 of Year 2022
  """

  @type elf_play :: :a | :b | :c
  @type you_play :: :x | :y | :z
  @type round :: {elf_play, you_play()}

  defmodule Common do
    @moduledoc """
    Common part for Day 2
    """
    @spec parse_input(nonempty_list(nonempty_binary())) ::
            nonempty_list(Aletopelta.Year2022.Day02.round())
    def parse_input(input) do
      Enum.reduce(input, [], fn line, acc ->
        [elf, you] =
          line
          |> String.downcase()
          |> String.split()
          |> Enum.map(&String.to_atom/1)

        [{elf, you} | acc]
      end)
    end

    @spec get_score(Aletopelta.Year2022.Day02.round()) :: integer()
    def get_score(round)

    def get_score({:a, :x}), do: 1 + 3
    def get_score({:a, :y}), do: 2 + 6
    def get_score({:a, :z}), do: 3 + 0
    def get_score({:b, :x}), do: 1 + 0
    def get_score({:b, :y}), do: 2 + 3
    def get_score({:b, :z}), do: 3 + 6
    def get_score({:c, :x}), do: 1 + 6
    def get_score({:c, :y}), do: 2 + 0
    def get_score({:c, :z}), do: 3 + 3
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    @spec execute([nonempty_binary(), ...]) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&Common.get_score/1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.map(&replace_move/1)
      |> Enum.sum_by(&Common.get_score/1)
    end

    defp replace_move({:a, :x}), do: {:a, :z}
    defp replace_move({:a, :y}), do: {:a, :x}
    defp replace_move({:a, :z}), do: {:a, :y}
    defp replace_move({:b, :x}), do: {:b, :x}
    defp replace_move({:b, :y}), do: {:b, :y}
    defp replace_move({:b, :z}), do: {:b, :z}
    defp replace_move({:c, :x}), do: {:c, :y}
    defp replace_move({:c, :y}), do: {:c, :z}
    defp replace_move({:c, :z}), do: {:c, :x}
  end
end
