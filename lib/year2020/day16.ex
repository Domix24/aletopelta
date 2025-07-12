defmodule Aletopelta.Year2020.Day16 do
  @moduledoc """
  Day 16 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: list(binary())
    @type ticket() :: list(integer())
    @type tickets() :: list(tickets())
    @type validation() :: %{binary() => list(Range.t())}

    @spec parse_input(input()) :: list(validation() | tickets())
    def parse_input(input) do
      input
      |> Enum.chunk_by(fn line -> line == "" end)
      |> Enum.with_index(&parse_section/2)
      |> Enum.reject(&(&1 == ""))
    end

    defp parse_section(section, 0),
      do:
        Map.new(section, fn line ->
          ~r/([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/
          |> Regex.run(line, capture: :all_but_first)
          |> transform_property()
        end)

    defp parse_section([""], _), do: ""

    defp parse_section([_ | section], _),
      do:
        Enum.map(section, fn line ->
          line
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
        end)

    defp transform_property([property | values]), do: {property, convert_values(values)}

    defp convert_values(values),
      do:
        values
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.map(fn [min, max] -> Range.new(min, max) end)

    @spec split_tickets(tickets(), validation()) :: {list(tickets()), list(tickets())}
    def split_tickets(tickets, validation),
      do: Enum.split_with(tickets, &validate_ticket?(&1, validation))

    defp validate_ticket?(ticket, validation), do: Enum.all?(ticket, &valid?(&1, validation))
    @spec valid?(integer(), validation()) :: boolean()
    def valid?(field, validation),
      do: Enum.any?(validation, fn {_, validator} -> Enum.any?(validator, &(field in &1)) end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare()
      |> Enum.sum()
    end

    defp prepare([validation, _, tickets]),
      do:
        tickets
        |> Common.split_tickets(validation)
        |> elem(1)
        |> Enum.flat_map(& &1)
        |> Enum.reject(&Common.valid?(&1, validation))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare()
    end

    defp prepare([validation, [ticket], tickets]),
      do:
        tickets
        |> Common.split_tickets(validation)
        |> elem(0)
        |> map_fields(validation, Map.new())
        |> elem(1)
        |> reduce_mapped()
        |> Enum.filter(fn {_, [name]} -> String.match?(name, ~r/^de/) end)
        |> Enum.map(&elem(&1, 0))
        |> map_ticket(ticket)

    defp map_fields([], validation, mapping), do: {validation, mapping}

    defp map_fields([ticket | tickets], validation, mapped) do
      ticket
      |> Enum.with_index()
      |> Enum.reduce({validation, mapped}, &breduce_ticket/2)
      |> cmap_fields(tickets)
    end

    defp breduce_ticket({field, index}, {validation_acc, mapped_acc}),
      do:
        mapped_acc
        |> Map.get(index, [])
        |> reduce_ticket(field, validation_acc)
        |> update_mapped(index, mapped_acc)
        |> update_validation(validation_acc)

    defp reduce_ticket([], field, validation_acc),
      do: Enum.flat_map(validation_acc, &field_valid(&1, field))

    defp reduce_ticket([_] = mapped, _, _), do: mapped

    defp reduce_ticket(mapped, field, validation_acc),
      do:
        validation_acc
        |> Enum.filter(&Enum.member?(mapped, elem(&1, 0)))
        |> Enum.flat_map(&field_valid(&1, field))

    defp field_valid({name, validate}, value),
      do:
        validate
        |> Enum.any?(&(value in &1))
        |> afield_valid(name)

    defp afield_valid(true, mapping), do: [mapping]
    defp afield_valid(false, _), do: []

    defp update_mapped(list, index, mapped_acc), do: {list, Map.put(mapped_acc, index, list)}

    defp update_validation({[name], mapping_acc}, validation_acc),
      do: {Map.delete(validation_acc, name), mapping_acc}

    defp update_validation({_, mapping_acc}, validation_acc), do: {validation_acc, mapping_acc}

    defp cmap_fields({validation, mapped}, tickets),
      do:
        validation
        |> Enum.count()
        |> cmap_fields(validation, mapped, tickets)

    defp cmap_fields(0, _, mapped, _), do: mapped
    defp cmap_fields(_, validation, mapped, tickets), do: map_fields(tickets, validation, mapped)

    defp reduce_mapped(mapped),
      do:
        mapped
        |> Enum.split_with(&(length(elem(&1, 1)) < 2))
        |> prepare_substract()

    defp prepare_substract({only_one, []}), do: only_one

    defp prepare_substract({only_one, many}),
      do:
        only_one
        |> Enum.flat_map(&elem(&1, 1))
        |> substract_many(many)
        |> combine_one(only_one)
        |> reduce_mapped()

    defp substract_many(substract, many),
      do: Enum.map(many, fn {index, list} -> {index, list -- substract} end)

    defp combine_one(result, ones), do: result ++ ones

    defp map_ticket(mapping, ticket),
      do:
        ticket
        |> Enum.with_index()
        |> Enum.filter(&Enum.member?(mapping, elem(&1, 1)))
        |> Enum.product_by(&elem(&1, 0))
  end
end
