defmodule Aletopelta.Year2021.Day04 do
  @moduledoc """
  Day 4 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """
    @spec parse_input(list(binary())) :: {list(binary()), list(list({binary(), boolean()}))}
    def parse_input(input) do
      [[numbers] | boards] =
        input
        |> Enum.chunk_by(fn line -> line == "" end)
        |> Enum.chunk_every(2)
        |> Enum.map(fn [first | _] ->
          Enum.map(first, &String.split(&1, [" ", ","], trim: true))
        end)

      {numbers, parse_boards(boards)}
    end

    defp parse_boards(boards) do
      Enum.map(boards, fn board ->
        Enum.map(board, fn line ->
          Enum.map(line, &{&1, false})
        end)
      end)
    end

    @spec get_score({binary(), list({binary(), boolean()})}) :: number()
    def get_score({number, board}) do
      unmarked =
        board
        |> Enum.flat_map(fn line ->
          line
          |> Enum.filter(fn {_, marked?} -> not marked? end)
          |> Enum.map(fn {number, false} -> String.to_integer(number) end)
        end)
        |> Enum.sum()

      String.to_integer(number) * unmarked
    end

    @spec draw_numbers({list(binary()), list(list({binary(), boolean()}))}, :first | :last) ::
            {binary(), list({binary(), boolean()})}
    def draw_numbers({numbers, boards}, opts) do
      draw_numbers(numbers, boards, 0, opts)
    end

    defp draw_numbers([], boards, _, _), do: boards
    defp draw_numbers(_, [], _, _), do: []

    defp draw_numbers([number | numbers], boards, drawn, :first) do
      new_drawn = drawn + 1

      result = mark_number(number, boards, new_drawn, :first)

      case result do
        {^number, _} = final ->
          final

        new_boards ->
          draw_numbers(numbers, new_boards, new_drawn, :first)
      end
    end

    defp draw_numbers([number | numbers], boards, drawn, :last) do
      new_drawn = drawn + 1

      {win_number, win_board, new_boards} = mark_number(number, boards, new_drawn, :last)

      case draw_numbers(numbers, new_boards, new_drawn, :last) do
        [] -> {win_number, win_board}
        result -> result
      end
    end

    defp mark_number(_, [], _, :first), do: []
    defp mark_number(_, [], _, :last), do: {nil, nil, []}

    defp mark_number(number, [board | boards], drawn, :first) do
      {_, win?, new_board, mark_index} = mark_number(number, board, drawn, :one)

      cond do
        win? ->
          {number, new_board}

        drawn > 4 and check_column(new_board, mark_index) ->
          {number, new_board}

        true ->
          case mark_number(number, boards, drawn, :first) do
            {_, _} = final -> final
            new_boards -> [new_board | new_boards]
          end
      end
    end

    defp mark_number(number, [board | boards], drawn, :last) do
      {_, win?, new_board, mark_index} = mark_number(number, board, drawn, :one)

      cond do
        win? ->
          handle_win(number, new_board, boards, drawn)

        drawn > 4 and check_column(new_board, mark_index) ->
          handle_win(number, new_board, boards, drawn)

        true ->
          {win_number, win_board, new_boards} = mark_number(number, boards, drawn, :last)

          {win_number, win_board, [new_board | new_boards]}
      end
    end

    defp mark_number(_, [], _, :one), do: {false, false, [], nil}

    defp mark_number(number, [line | lines], drawn, :one) do
      {marked?, new_line, mark_index} = mark_number(number, line, 0, :two)

      win? =
        if marked? and drawn > 4 do
          check_win(new_line)
        else
          false
        end

      if marked? do
        {marked?, win?, [new_line | lines], mark_index}
      else
        {new_marked?, new_win?, next_lines, new_mark} = mark_number(number, lines, drawn, :one)

        {new_marked?, new_win?, [line | next_lines], new_mark}
      end
    end

    defp mark_number(_, [], _, :two), do: {false, [], nil}

    defp mark_number(number, [{number, false} | cells], index, :two) do
      {true, [{number, true} | cells], index}
    end

    defp mark_number(number, [cell | cells], index, :two) do
      {marked?, new_cells, mark_index} = mark_number(number, cells, index + 1, :two)

      {marked?, [cell | new_cells], mark_index}
    end

    defp check_win(line) do
      Enum.all?(line, fn {_, marked?} -> marked? end)
    end

    defp check_column(_, nil), do: false
    defp check_column([], _), do: true

    defp check_column([line | lines], index) do
      if check_column(line, index, 0) do
        check_column(lines, index)
      else
        false
      end
    end

    defp check_column([{_, marked?} | _], index, index), do: marked?
    defp check_column([_ | cells], index, currrent), do: check_column(cells, index, currrent + 1)

    defp handle_win(number, new_board, boards, drawn) do
      {_, other_board, new_boards} = mark_number(number, boards, drawn, :last)

      if other_board == nil do
        {number, new_board, new_boards}
      else
        {number, other_board, new_boards}
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(list(binary()), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.draw_numbers(:first)
      |> Common.get_score()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(list(binary()), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.draw_numbers(:last)
      |> Common.get_score()
    end
  end
end
