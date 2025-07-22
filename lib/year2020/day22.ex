defmodule Aletopelta.Year2020.Day22 do
  @moduledoc """
  Day 22 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(integer()))
    def parse_input(input) do
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn [_ | cards] -> Enum.map(cards, &String.to_integer/1) end)
    end

    @spec play(list(integer()), list(integer())) :: {list(integer()), list(integer())}
    def play([card_player1 | cards_player1], [card_player2 | cards_player2])
        when card_player1 > card_player2 do
      {cards_player1 ++ [card_player1, card_player2], cards_player2}
    end

    def play([card_player1 | cards_player1], [card_player2 | cards_player2]) do
      {cards_player1, cards_player2 ++ [card_player2, card_player1]}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_rounds()
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.sum_by(fn {card, position} -> card * position end)
    end

    defp do_rounds([player1, player2]) do
      player1
      |> Common.play(player2)
      |> continue()
    end

    defp continue({[_ | _] = cards1, [_ | _] = cards2}), do: do_rounds([cards1, cards2])
    defp continue({[], cards}), do: cards
    defp continue({cards, []}), do: cards
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_rounds(Map.new())
      |> get_winnercards()
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.sum_by(fn {card, position} -> card * position end)
    end

    defp get_winnercards({[], cards}), do: cards
    defp get_winnercards({cards, []}), do: cards

    defp do_rounds([player1, player2], cache) do
      state =
        case check_cache(cache, [player1, player2]) do
          :found -> :win
          key -> Map.put(cache, key, 1)
        end

      player1
      |> play(player2, state)
      |> continue(state)
    end

    defp check_cache(cache, players) do
      key = get_key(players)

      if Map.has_key?(cache, get_key(players)) do
        :found
      else
        key
      end
    end

    defp get_key(players) do
      players
    end

    defp play(_, _, :win), do: :win

    defp play([card_player1 | cards_player1], [card_player2 | cards_player2], _)
         when length(cards_player1) >= card_player1 and length(cards_player2) >= card_player2 do
      case do_rounds(
             [Enum.take(cards_player1, card_player1), Enum.take(cards_player2, card_player2)],
             Map.new()
           ) do
        :win -> {cards_player1 ++ [card_player1, card_player2], cards_player2}
        {[], _} -> {cards_player1, cards_player2 ++ [card_player2, card_player1]}
        {_, []} -> {cards_player1 ++ [card_player1, card_player2], cards_player2}
      end
    end

    defp play(cards_player1, cards_player2, _) do
      Common.play(cards_player1, cards_player2)
    end

    defp continue(_, :win), do: :win

    defp continue({[_ | _] = cards1, [_ | _] = cards2}, cache),
      do: do_rounds([cards1, cards2], cache)

    defp continue({[], _} = decks, _), do: decks
    defp continue({_, []} = decks, _), do: decks
  end
end
