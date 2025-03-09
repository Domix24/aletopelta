defmodule Aletopelta.Year2023.Day07 do
  @moduledoc """
  Day 7 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """
    def parse_input([line]) do
      [parse_line(line)]
    end

    def parse_input([line | others]) do
      [parse_line(line) | parse_input(others)]
    end

    def parse_line(line) do
      [cards, bid] = String.split(line)

      cards =
        String.graphemes(cards)
        |> Enum.map(&convert_card/1)

      bid = String.to_integer(bid)

      %{cards: cards, bid: bid}
    end

    defp convert_card("A"), do: ?Z
    defp convert_card("K"), do: ?Y
    defp convert_card("Q"), do: ?X
    defp convert_card("J"), do: ?W
    defp convert_card("T"), do: ?V
    defp convert_card("9"), do: ?U
    defp convert_card("8"), do: ?T
    defp convert_card("7"), do: ?S
    defp convert_card("6"), do: ?R
    defp convert_card("5"), do: ?Q
    defp convert_card("4"), do: ?P
    defp convert_card("3"), do: ?O
    defp convert_card("2"), do: ?N
    defp convert_card(x), do: raise(x)

    def get_type(%{cards: cards} = map) do
      card_group = Enum.group_by(cards, & &1)

      cond do
        five?(card_group) -> Map.put(map, :type, :five)
        four?(card_group) -> Map.put(map, :type, :four)
        full?(card_group) -> Map.put(map, :type, :full)
        three?(card_group) -> Map.put(map, :type, :three)
        two?(card_group) -> Map.put(map, :type, :two)
        one?(card_group) -> Map.put(map, :type, :one)
        true -> Map.put(map, :type, :high)
      end
    end

    defp five?(cards), do: Enum.count(cards) == 1
    defp full?(cards), do: Enum.count(cards) == 2
    defp two?(cards), do: Enum.count(cards) == 3
    defp one?(cards), do: Enum.count(cards) == 4

    defp four?(cards) do
      Enum.reduce(cards, {0, 0, :ok}, fn {_, group}, {nbfours, nbones, state} ->
        {nbfours, nbones, Enum.count(group)}
        |> case do
          {0, _, 4} -> {1, nbones, state}
          {_, 0, 1} -> {nbfours, 1, state}
          _ -> {0, 0, :overflow}
        end
      end)
      |> case do
        {_, _, :overflow} -> false
        {1, 1, _} -> true
        _ -> false
      end
    end

    defp three?(cards) do
      Enum.reduce(cards, {0, 0, :ok}, fn {_, group}, {nbthrees, nbones, state} ->
        {nbthrees, nbones, Enum.count(group)}
        |> case do
          {0, _, 3} -> {1, nbones, state}
          {_, _, 1} -> {nbthrees, nbones + 1, state}
          _ -> {0, 0, :overflow}
        end
      end)
      |> case do
        {_, _, :overflow} -> false
        {1, 2, _} -> true
        _ -> false
      end
    end

    defp get_strength(type: :high), do: 1
    defp get_strength(type: :one), do: 2
    defp get_strength(type: :two), do: 3
    defp get_strength(type: :three), do: 4
    defp get_strength(type: :full), do: 5
    defp get_strength(type: :four), do: 6
    defp get_strength(type: :five), do: 7

    def do_sort([type: type, cards: card1], type: type, cards: card2) do
      compare_card(card1, card2)
    end

    def do_sort([type: type1, cards: _], type: type2, cards: _) do
      get_strength(type: type1) < get_strength(type: type2)
    end

    defp compare_card([card | lothers], [card | rothers]) do
      compare_card(lothers, rothers)
    end

    defp compare_card([lcard | _], [rcard | _]) do
      lcard < rcard
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&Common.get_type/1)
      |> Enum.sort_by(&[type: &1.type, cards: &1.cards], &Common.do_sort/2)
      |> Enum.with_index(&(&1.bid * (&2 + 1)))
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    def execute(input) do
      Common.parse_input(input)
      |> update_jvalue
      |> Enum.map(&Common.get_type/1)
      |> Enum.map(&upgrade_type/1)
      |> Enum.sort_by(&[type: &1.type, cards: &1.cards], &Common.do_sort/2)
      |> Enum.with_index(&(&1.bid * (&2 + 1)))
      |> Enum.sum()
    end

    defp update_jvalue([]), do: []

    defp update_jvalue([line | others]) do
      line = Map.put(line, :cards, update_jvalue(line.cards, 1))
      others = update_jvalue(others)

      [line | others]
    end

    defp update_jvalue([], 1), do: []
    defp update_jvalue([?W | others], 1), do: [?A | update_jvalue(others, 1)]
    defp update_jvalue([nu | others], 1), do: [nu | update_jvalue(others, 1)]

    defp upgrade_type(line) do
      if Enum.any?(line.cards, &(?A == &1)) do
        nbj = Enum.count(line.cards, &(?A == &1))

        type =
          case {nbj, line.type} do
            {_, :five} -> :five
            {_, :four} -> :five
            {_, :full} -> :five
            {_, :three} -> :four
            {1, :two} -> :full
            {2, :two} -> :four
            {_, :one} -> :three
            {_, :high} -> :one
          end

        Map.put(line, :type, type)
      else
        line
      end
    end
  end
end
