defmodule Aletopelta.Year2019.Day25 do
  @moduledoc """
  Day 25 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """

    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> build_graph()
      |> to_security()
      |> test_pressure()
      |> String.to_integer()
    end

    defp test_pressure(state) do
      items = get_inventory(state.memory)

      1..4
      |> Stream.flat_map(&combination(items, &1))
      |> Enum.find_value(fn dropitems ->
        command = Enum.map_join(dropitems, "\n", &"drop #{&1}")

        text =
          state.memory
          |> run_command(command)
          |> elem(0)
          |> run_command(state.pressure)
          |> elem(1)
          |> Enum.reverse()
          |> then(&"#{&1}")

        heavier? = Regex.match?(~r"are heavier than", text)
        lighter? = Regex.match?(~r"are lighter than", text)

        if not heavier? and not lighter? do
          ~r"\d+"
          |> Regex.run(text)
          |> Enum.at(0)
        end
      end)
    end

    defp combination(_, 0), do: [[]]
    defp combination([], _), do: []

    defp combination([head | tail], len) do
      with_head = for comb <- combination(tail, len - 1), do: [head | comb]
      with_head ++ combination(tail, len)
    end

    defp get_inventory(intcode) do
      {_, old_output} = run_command(intcode, "inv")

      output = "#{Enum.reverse(old_output)}"

      ~r/- ([a-z][a-z ]+[a-z])/
      |> Regex.scan(output, capture: :all_but_first)
      |> Enum.flat_map(& &1)
    end

    defp to_security(%{graph: graph, memory: memory} = node) do
      [pressure | security] =
        graph
        |> Map.fetch!("Hull Breach")
        |> Enum.map(&[&1])
        |> get_security(node)

      input =
        security
        |> Enum.reverse()
        |> Enum.join("\n")

      {new_memory, _} = run_command(memory, input)

      %{pressure: pressure, memory: new_memory, graph: graph}
    end

    defp get_security(sides, %{graph: graph}) do
      %{graph: graph, list: sides}
      |> Stream.iterate(&next_depth/1)
      |> Enum.find_value(fn %{list: list} ->
        Enum.find(list, fn [{_, room} | _] -> room === "Pressure-Sensitive Floor" end)
      end)
      |> Enum.map(&elem(&1, 0))
    end

    defp next_depth(%{graph: graph, list: list}) do
      new_list =
        Enum.flat_map(list, fn [{_, room} | _] = sublist ->
          graph
          |> Map.get(room, [])
          |> Enum.map(&[&1 | sublist])
        end)

      %{graph: graph, list: new_list}
    end

    defp build_graph(intcode) do
      intcode
      |> prepare_graph()
      |> Stream.iterate(&next_node/1)
      |> Enum.find(fn %{backhome?: backhome?} -> backhome? end)
      |> then(fn %{grid: grid, memory: memory} ->
        graph =
          Enum.group_by(grid, fn {{_, source}, _} -> source end, fn {{direction, _}, target} ->
            {direction, target}
          end)

        %{graph: graph, memory: memory}
      end)
    end

    defp prepare_graph(intcode) do
      {memory, output, _} = Intcode.prepare(intcode)

      %{name: name, doors: doors} = process_output(output)

      grid = Map.new(doors, &{{&1, name}, :intcode})

      %{memory: memory, grid: grid, actual: name, path: [], backhome?: false}
    end

    defp process_node(nil, %{memory: memory, grid: grid, actual: actual, path: path}) do
      case path do
        [] ->
          %{memory: memory, grid: grid, actual: actual, path: path, backhome?: true}

        temp_path ->
          [{direction, new_actual} | new_path] =
            case temp_path do
              [{_, "Security Checkpoint"} | rest_path] -> rest_path
              rest_path -> rest_path
            end

          {new_memory, _} = run_command(memory, inverse(direction))

          %{grid: grid, memory: new_memory, actual: new_actual, path: new_path, backhome?: false}
      end
    end

    defp process_node(node, _), do: node

    defp get_node({{destination, initial_name}, :intcode}, %{
           grid: grid,
           memory: memory,
           path: path
         }) do
      {new_memory, output} = run_command(memory, destination)
      %{name: name, items: items, doors: doors} = process_output(output)

      updated_memory = take_items(items, new_memory)

      new_doors = Enum.reject(doors, &(&1 === inverse(destination)))

      new_grid =
        grid
        |> Map.put({destination, initial_name}, name)
        |> update_grid(new_doors, name)

      %{
        grid: new_grid,
        memory: updated_memory,
        actual: name,
        path: [{destination, initial_name} | path],
        backhome?: false
      }
    end

    defp get_node(%{grid: _, memory: _, actual: _, path: _} = node, _), do: node

    defp update_grid(grid, [], _), do: grid

    defp update_grid(grid, doors, name) do
      Enum.reduce(doors, grid, fn door, acc ->
        Map.put(acc, {door, name}, :intcode)
      end)
    end

    defp take_items(items, memory) do
      items
      |> Enum.reject(&forbidden_item?/1)
      |> Enum.reduce(memory, fn item, submemory ->
        submemory
        |> take_item(item)
        |> elem(0)
      end)
    end

    defp next_node(%{grid: grid, actual: actual} = node) do
      grid
      |> Enum.find(fn
        {{_, ^actual}, :intcode} -> true
        _ -> false
      end)
      |> process_node(node)
      |> get_node(node)
    end

    defp process_output(output) do
      name_regex = ~r/== (.*) ==/
      doors_regex = ~r/Doors here lead:((?:\n- [a-z]+)+)/
      items_regex = ~r/Items here:((?:\n- [a-z ]+)+)/
      word_regex = ~r/[a-z][a-z ]+/

      reversed = Enum.reverse(output)
      full = "#{reversed}"

      doors = process_content(full, doors_regex, word_regex)
      items = process_content(full, items_regex, word_regex)
      name = process_name(full, name_regex)

      %{doors: doors, name: name, items: items}
    end

    defp process_content(text, regex, word) do
      regex
      |> Regex.run(text, capture: :all_but_first)
      |> first_nil()
      |> then(fn text -> Regex.scan(word, text) end)
      |> Enum.flat_map(& &1)
    end

    defp process_name(text, regex) do
      regex
      |> Regex.run(text, capture: :all_but_first)
      |> first_nil()
    end

    defp first_nil(nil), do: ""
    defp first_nil([first | _]), do: first

    defp run_command(intcode, unparsed) do
      input =
        ~s"""
        a
        """
        |> String.replace("a", unparsed)
        |> String.to_charlist()

      {memory, output, _} = Intcode.continue(intcode, input)

      {memory, output}
    end

    defp take_item(intcode, unparsed) do
      run_command(intcode, "take #{unparsed}")
    end

    defp forbidden_item?(item),
      do:
        Enum.member?(
          ["molten lava", "infinite loop", "escape pod", "photons", "giant electromagnet"],
          item
        )

    defp inverse("south"), do: "north"
    defp inverse("north"), do: "south"
    defp inverse("west"), do: "east"
    defp inverse("east"), do: "west"
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: 0
    def execute(input, []) do
      Common.parse_input(input)
      0
    end
  end
end
