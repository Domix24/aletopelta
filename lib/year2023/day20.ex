defmodule Aletopelta.Year2023.Day20 do
  @moduledoc """
  Day 20 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """
    def parse_input(input) do
      {broadcaster, flipflops, conjunctions} = Enum.reduce(input, %{}, fn line, map ->
        [name, _ | others] = String.split line, [",", " "], trim: true
        others = Enum.map others, &String.to_atom/1

        case name do
          "broadcaster" ->
            Map.put map, :broadcaster, others

          "%" <> rest ->
            Map.put map, {:flipflop, String.to_atom rest}, {:off, others}

          "&" <> rest ->
            Map.put map, {:conjunction, String.to_atom rest}, {:low, others}
        end
      end) |> split

      {conjunctions, flipflops} = connect_input conjunctions, flipflops

      {broadcaster, flipflops, conjunctions}
    end

    defp split map do
      Enum.reduce map, {nil, %{}, %{}}, fn
        {:broadcaster, modules}, {_, flipflops, conjunctions} ->
          modules = identify map, modules

          {modules, flipflops, conjunctions}

        {{:flipflop, name}, {state, modules}}, {broadcaster, flipflops, conjunctions} ->
          modules = identify map, modules
          flipflops = Map.put flipflops, name, {state, [], modules}

          {broadcaster, flipflops, conjunctions}

        {{:conjunction, name}, {state, modules}}, {broadcaster, flipflops, conjunctions} ->
          modules = identify map, modules
          conjunctions = Map.put conjunctions, name, {state, [], modules}

          {broadcaster, flipflops, conjunctions}
      end
    end

    defp identify map, modules do
      Enum.map modules, fn module ->
        cond do
          Map.has_key? map, {:flipflop, module} ->
            {:flipflop, module}

          Map.has_key? map, {:conjunction, module} ->
            {:conjunction, module}

          module in [:output, :rx] ->
            {:special, module}
        end
      end
    end

    defp connect_input conjunctions, flipflops do
      complete = Map.merge conjunctions, flipflops
      {result, flipflops, _} = Enum.reduce conjunctions, {%{}, flipflops, conjunctions}, fn {name, {state, _, modules}}, {result, flipflops, conjunctions} ->
        {inputs, flipflops, conjunctions} = Enum.reduce complete, {%{}, flipflops, conjunctions}, fn
          {^name, _}, acc ->
            acc

          {module, {_, _, modules}}, acc ->
            find_link modules, acc, name, module, state
        end

        result = Map.put result, name, {state, inputs, modules}
        {result, flipflops, conjunctions}
      end

      {result, flipflops}
    end

    defp find_link modules, acc, name, module, state do
      Enum.reduce modules, acc, fn
        {:conjunction, ^name}, {result, flipflops, conjunctions} ->
          {flipflops, conjunctions} = update_table flipflops, conjunctions, module, name

          result = Map.put result, module, state
          {result, flipflops, conjunctions}

       _, acc ->
         acc
      end
    end

    defp update_table flipflops, conjunctions, module, name do
      cond do
        Map.has_key? flipflops, module ->
          flipflops = update_flipflops flipflops, module, name
          {flipflops, conjunctions}

        Map.has_key? conjunctions, module ->
          conjunctions = update_conjunctions conjunctions, module, name
          {flipflops, conjunctions}
      end
    end

    defp update_flipflops flipflops, module, name do
      Map.update! flipflops, module, fn {state, links, modules} ->
        links = [name | links]
        {state, links, modules}
      end
    end

    defp update_conjunctions conjunctions, module, name do
      Map.update! conjunctions, module, fn {state, links, modules} ->
        links = [name | links]
        {state, links, modules}
      end
    end

    def process [], {flipflops, conjunctions}, [], count, wrote, _ do
      {flipflops, conjunctions, count, wrote}
    end
    def process [], {flipflops, conjunctions}, next_modules, count, wrote, links do
      count = Enum.reduce next_modules, count, fn
        {:low, _, _}, {high, low} -> {high, low + 1}
        {:high, _, _}, {high, low} -> {high + 1, low}
      end
      process next_modules, {flipflops, conjunctions}, [], count, wrote, links
    end
    def process [module | modules], {flipflops, conjunctions}, next_modules, count, wrote, links do
      wrote = case module do
        {:high, {_, _}, source}  ->
          if source in links do
            ["#{source}" | wrote]
          else
            wrote
          end

        _ ->
          wrote
      end

      {flipflops, conjunctions, next_modules} = case module do
        {:low, {:flipflop, name}, _} ->
          {{state, _, modules}, flipflops} = Map.get_and_update! flipflops, name, fn
            {:off, links, modules} = current -> {current, {:on, links, modules}}
            {:on, links, modules} = current -> {current, {:off, links, modules}}
          end

          append = case state do
            :off ->
              toggle_modules modules, name, :high
            :on ->
              toggle_modules modules, name, :low
          end

          next_modules = next_modules ++ append

          {flipflops, conjunctions, next_modules}

        {:high, {:flipflop, _}, _} ->
          {flipflops, conjunctions, next_modules}

        {state, {:conjunction, name}, source} ->
          {{_, memory, modules}, conjunctions} =
            Map.get_and_update! conjunctions, name, fn {sub_state, links, modules} ->
              links = Map.put links, source, state
              new_value = {sub_state, links, modules}

              {new_value, new_value}
            end

          state = Enum.any?(memory, fn
            {_, :low} -> true
            {_, :high} -> false
          end) |> case do
            true -> :high
            false -> :low
          end

          append = Enum.map modules, fn module ->
            {state, module, name}
          end

          next_modules = next_modules ++ append

          {flipflops, conjunctions, next_modules}

        {_, {:special, _}, _} ->
          {flipflops, conjunctions, next_modules}

       end

       process modules, {flipflops, conjunctions}, next_modules, count, wrote, links
    end

    defp toggle_modules modules, name, state do
      Enum.map modules, fn module ->
        {state, module, name}
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    def execute(input) do
      Common.parse_input(input)
      |> push_button(1000)
    end

    defp push_button {broadcaster, flipflops, conjunctions}, count do
      initial_pulse = Enum.map broadcaster, &{:low, &1, :broadcaster}
      initial_count = length(initial_pulse) + 1

      Enum.reduce(1..count//1, {flipflops, conjunctions, {0, 0}, 0}, fn _, {flipflops, conjunctions, {high, low}, _} ->
        Common.process initial_pulse, {flipflops, conjunctions}, [], {high, low + initial_count}, [], []
      end)
      |> then(fn {_, _, {high, low}, _} -> high * low end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    def execute(input) do
      Common.parse_input(input)
      |> push_button(1000 * 5)
    end

    defp push_button {broadcaster, flipflops, conjunctions}, count do
      initial_pulse = Enum.map broadcaster, &{:low, &1, :broadcaster}
      initial_count = length(initial_pulse) + 1

      links = Enum.find_value conjunctions, fn
        {_, {_, links, [special: :rx]}} -> Map.keys links
        _ -> false
      end

      Enum.reduce_while(1..count//1, {flipflops, conjunctions, {0, 0}, []}, fn index, {flipflops, conjunctions, {high, low}, wrote} ->
        {flipflops, conjunctions, _, wroting} =
          Common.process initial_pulse, {flipflops, conjunctions}, [], {high, low + initial_count}, [], links

        wroting = Enum.map wroting, &{&1, index}

        case wroting do
          [] ->
            {:cont, {flipflops, conjunctions, {0, 0}, wrote}}

          [wroting] ->
            wrote = [wroting | wrote]
            dispatch_wrote length(wrote), wrote, flipflops, conjunctions
        end
      end) |> then(fn {_, _, _, write} -> calculate_least write end)
    end

    defp dispatch_wrote 4, wrote, _, _ do
      {:halt, {0, 0, {0, 0}, wrote}}
    end
    defp dispatch_wrote _, wrote, flipflops, conjunctions do
      {:cont, {flipflops, conjunctions, {0, 0}, wrote}}
    end

    defp calculate_least [{_, number}] do
      number
    end
    defp calculate_least [{_, number} | others] do
      lcm number, calculate_least others
    end

    defp gcd(0, 0), do: 0
    defp gcd(a, a), do: a
    defp gcd(a, b) when a > b, do: gcd(a - b, b)
    defp gcd(a, b), do: gcd(a, b - a)

    defp lcm(a, b), do: (a * b) / gcd(a, b)
  end
end
