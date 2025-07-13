defmodule Aletopelta.Year2020.Day19 do
  @moduledoc """
  Day 19 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())
    @type rules() :: %{integer() => instructions()}
    @type instructions :: list(:instructions | instruction())
    @type instruction :: list(:instruction | integer())

    @spec parse_input(input()) :: [rules() | list(binary())]
    def parse_input(input) do
      input
      |> Enum.chunk_by(fn line -> line == "" end)
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {[""], _} -> []
        {rules, 0} -> [parse_rules(rules)]
        {messages, 2} -> [messages]
      end)
    end

    defp parse_rules(rules),
      do:
        Map.new(rules, fn rule ->
          [sname | sinstructions] = Regex.run(~r/(\d+): (.+)/, rule, capture: :all_but_first)

          name = String.to_integer(sname)

          instructions =
            sinstructions
            |> Enum.at(0)
            |> String.split("|")
            |> Enum.map(&parse_instruction/1)

          {name, [:instructions | instructions]}
        end)

    defp parse_instruction(instruction) do
      value =
        ~r/(\d+|a|b)/
        |> Regex.scan(instruction, capture: :all_but_first)
        |> Enum.map(fn
          [letter] when letter in ["a", "b"] -> letter
          [number] -> String.to_integer(number)
        end)

      [:instruction | value]
    end

    defp get_joiner(:instruction), do: ""
    defp get_joiner(:instructions), do: "|"

    defp build_string(final, :instruction), do: "#{final}"
    defp build_string(final, :instructions), do: "(#{final})"

    defp before_expand(rules, number),
      do:
        rules
        |> expand(Map.fetch!(rules, number))
        |> String.replace("(b)", "b")
        |> String.replace("(a)", "a")

    defp expand(rules, [type | instructions]) when type in [:instruction, :instructions],
      do:
        instructions
        |> Enum.map_join(get_joiner(type), &expand(rules, &1))
        |> build_string(type)

    defp expand(rules, rule) when is_integer(rule), do: expand(rules, Map.fetch!(rules, rule))
    defp expand(_, rule) when rule in ["a", "b"], do: rule

    @spec get_expand(rules()) :: {binary(), binary()}
    def get_expand(rules) do
      expand_42 = before_expand(rules, 42)
      expand_31 = before_expand(rules, 31)

      {expand_42, expand_31}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_test()
    end

    defp prepare_test([rules, messages]) do
      {expanded_42, expanded_31} = Common.get_expand(rules)

      expression = ~r/^(#{expanded_42}){2}(#{expanded_31}){1}$/

      Enum.count(messages, &String.match?(&1, expression))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_test()
    end

    defp prepare_test([rules, messages]) do
      {expanded_42, expanded_31} = Common.get_expand(rules)

      {_, count} =
        Enum.reduce(1..4, {messages, 0}, fn index, {messages_acc, result} ->
          new_expression =
            ~r/^(#{expanded_42})+(#{expanded_42}){#{index}}(#{expanded_31}){#{index}}$/

          {matchs, no_matchs} = Enum.split_with(messages_acc, &String.match?(&1, new_expression))

          {no_matchs, length(matchs) + result}
        end)

      count
    end
  end
end
