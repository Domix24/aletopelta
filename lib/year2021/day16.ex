defmodule Aletopelta.Year2021.Day16 do
  @moduledoc """
  Day 16 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: [binary()]
    @type output() :: binary()

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> parse_char()
    end

    defp parse_char(""), do: ""

    defp parse_char(<<sign, rest::binary>>) do
      binary =
        <<sign>>
        |> Integer.parse(16)
        |> elem(0)
        |> Integer.to_string(2)
        |> String.pad_leading(4, "0")

      binary <> parse_char(rest)
    end

    @spec traverse(output()) :: {map(), binary()}
    def traverse(<<v::size(8 * 3), "100", rest::binary>>) do
      version = String.to_integer("#{<<v::size(8 * 3)>>}", 2)
      type = 4

      {binary, new_rest} = traverse_literal(rest)
      number = String.to_integer(binary, 2)

      {%{version: version, type: type, number: number}, new_rest}
    end

    def traverse(<<v::size(8 * 3), t::size(8 * 3), "0", l::size(8 * 15), rest::binary>>) do
      version = String.to_integer("#{<<v::size(8 * 3)>>}", 2)
      type = String.to_integer("#{<<t::size(8 * 3)>>}", 2)
      length = String.to_integer("#{<<l::size(8 * 15)>>}", 2)

      split = fn <<sp::size(8 * ^length), new_rest::binary>> -> {sp, new_rest} end
      {sp, new_rest} = split.(rest)

      sub_packet = <<sp::size(8 * length)>>

      sub_packets = traverse_subpacket(sub_packet)

      {%{version: version, type: type, sub_packets: sub_packets}, new_rest}
    end

    def traverse(<<v::size(8 * 3), t::size(8 * 3), "1", l::size(8 * 11), rest::binary>>) do
      version = String.to_integer("#{<<v::size(8 * 3)>>}", 2)
      type = String.to_integer("#{<<t::size(8 * 3)>>}", 2)
      packet_count = String.to_integer("#{<<l::size(8 * 11)>>}", 2)

      {sub_packets, new_rest} =
        Enum.map_reduce(1..packet_count, rest, fn _, acc ->
          traverse(acc)
        end)

      {%{version: version, type: type, sub_packets: sub_packets}, new_rest}
    end

    defp traverse_literal(<<"1", g::size(8 * 4), rest::binary>>) do
      {value, new_rest} = traverse_literal(rest)

      {<<g::size(8 * 4), value::binary>>, new_rest}
    end

    defp traverse_literal(<<"0", g::size(8 * 4), rest::binary>>) do
      {<<g::size(8 * 4)>>, rest}
    end

    defp traverse_subpacket(""), do: []

    defp traverse_subpacket(<<_, _::binary>> = subpacket) do
      {value, rest} = traverse(subpacket)

      [value | traverse_subpacket(rest)]
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> version()
    end

    defp version({packets, _}), do: version(packets)

    defp version(%{version: version, sub_packets: sub_packets}) do
      version + version(sub_packets)
    end

    defp version(%{version: version}), do: version
    defp version([]), do: 0

    defp version([packet | packets]) do
      version(packet) + version(packets)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.traverse()
      |> evaluate()
    end

    defp evaluate({packet, _}), do: evaluate(packet)

    defp evaluate(%{type: 0, sub_packets: sub_packets}) do
      Enum.sum_by(sub_packets, fn packet -> evaluate(packet) end)
    end

    defp evaluate(%{type: 1, sub_packets: sub_packets}) do
      Enum.product_by(sub_packets, fn packet -> evaluate(packet) end)
    end

    defp evaluate(%{type: 2, sub_packets: sub_packets}) do
      result = Enum.min_by(sub_packets, fn packet -> evaluate(packet) end)
      evaluate(result)
    end

    defp evaluate(%{type: 3, sub_packets: sub_packets}) do
      result = Enum.max_by(sub_packets, fn packet -> evaluate(packet) end)
      evaluate(result)
    end

    defp evaluate(%{type: 4, number: number}), do: number

    defp evaluate(%{type: 5, sub_packets: [packet1, packet2]}) do
      if evaluate(packet1) > evaluate(packet2), do: 1, else: 0
    end

    defp evaluate(%{type: 6, sub_packets: [packet1, packet2]}) do
      if evaluate(packet1) < evaluate(packet2), do: 1, else: 0
    end

    defp evaluate(%{type: 7, sub_packets: [packet1, packet2]}) do
      if evaluate(packet1) == evaluate(packet2), do: 1, else: 0
    end
  end
end
