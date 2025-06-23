defmodule Aletopelta.Year2021.Day21 do
  @moduledoc """
  Day 21 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """

    @type input() :: [binary()]
    @type output() :: [player()]
    @type player() :: %{id: integer(), position: integer(), score: integer()}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [id, position] =
          ~r/\d+/
          |> Regex.scan(line)
          |> Enum.map(fn [number] -> String.to_integer(number) end)

        %{id: id, position: position, score: 0}
      end)
    end

    @spec update_player(player(), integer()) :: player()
    def update_player(player, dicesum) do
      new_position = rem(player.position - 1 + dicesum, 10) + 1
      new_score = player.score + new_position

      %{player | position: new_position, score: new_score}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> start_game()
      |> finish_game()
    end

    defp start_game(players) do
      {players, 0, 0, true}
      |> Stream.iterate(&handle_iterate/1)
      |> Stream.transform(:continue, &handle_transform/2)
      |> Enum.at(0)
    end

    defp handle_iterate({_, _, _, false}), do: nil

    defp handle_iterate({[_, player2] = players, die, roll, true}) do
      {[new_player1, new_player2] = played_players, new_die} = play_turn(players, die)

      {new_players, new_roll, new_run} =
        cond do
          new_player1.score > 999 -> {player2, roll + 3, false}
          new_player2.score > 999 -> {new_player1, roll + 6, false}
          true -> {played_players, roll + 6, true}
        end

      {new_players, new_die, new_roll, new_run}
    end

    defp handle_transform(_, :stop), do: {:halt, nil}
    defp handle_transform({losing, _, rolls, false}, :continue), do: {[{losing, rolls}], :stop}
    defp handle_transform(_, :continue), do: {[], :continue}

    defp play_turn([], die), do: {[], die}

    defp play_turn([player | others], die) do
      {result, new_die} = roll_dice(die)

      new_player = Common.update_player(player, result)

      {others_players, final_die} = play_turn(others, new_die)

      {[new_player | others_players], final_die}
    end

    defp roll_dice(die) do
      Enum.reduce(1..3, {0, die}, fn _, {acc_result, acc_die} ->
        updated_die = acc_die + 1
        new_die = if updated_die > 100, do: 1, else: updated_die

        {acc_result + new_die, new_die}
      end)
    end

    defp finish_game({player, roll}), do: player.score * roll
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> start_game()
    end

    defp start_game([player1, player2]) do
      {player1, player2, _} = before_game(player1, player2, Map.new())

      max(player1, player2)
    end

    defp before_game(current_player, other_player, memory) do
      memory_key =
        {current_player.position, current_player.score, other_player.position, other_player.score}

      case Map.fetch(memory, memory_key) do
        {:ok, {current_wins, other_wins}} ->
          {current_wins, other_wins, memory}

        :error ->
          {current_wins, other_wins, acc_memory} = do_game(current_player, other_player, memory)

          new_memory = Map.put(acc_memory, memory_key, {current_wins, other_wins})
          {current_wins, other_wins, new_memory}
      end
    end

    defp do_game(current_player, other_player, memory) do
      for roll <- product([1, 2, 3], 3), reduce: {0, 0, memory} do
        {acc_current, acc_other, acc_memory} ->
          rollsum = Enum.sum(roll)

          new_player = Common.update_player(current_player, rollsum)

          if new_player.score > 20 do
            {acc_current + 1, acc_other, acc_memory}
          else
            {other_wins, current_wins, new_memory} =
              before_game(other_player, new_player, acc_memory)

            {acc_current + current_wins, acc_other + other_wins, new_memory}
          end
      end
    end

    defp product(_, 0), do: [[]]

    defp product(list, repeat) do
      for head <- list,
          tail <- product(list, repeat - 1) do
        [head | tail]
      end
    end
  end
end
