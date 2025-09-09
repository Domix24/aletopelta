defmodule Aletopelta.Year2019.Day11 do
  @moduledoc """
  Day 11 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type grid() :: %{coord() => integer()}
    @type coord() :: {integer(), integer()}
    @type robot() :: %{:position => coord(), :facing => 0 | 1 | 2 | 3, :stopped => boolean()}

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end

    @spec do_loop(grid(), Intcode.memory(), robot()) :: grid()
    def do_loop(grid, _, %{stopped: true}), do: grid

    def do_loop(grid, memory, robot) do
      grid
      |> get_input(robot)
      |> prepare(memory)
      |> set_grid(grid, robot)
    end

    defp get_input(grid, %{position: position}), do: Map.get(grid, position, 0)

    defp prepare(input, memory), do: Intcode.continue(memory, [input])

    defp set_grid({memory, [direction, floor], state}, grid, %{position: position} = robot) do
      grid
      |> Map.put(position, floor)
      |> prepare_move(memory, direction, state, robot)
    end

    defp prepare_move(grid, memory, direction, state, robot) do
      robot
      |> rotate_robot(direction)
      |> move_robot(robot)
      |> set_status(state)
      |> Map.new()
      |> align(grid, memory)
    end

    defp rotate_robot(%{facing: facing}, 0), do: [facing: rem(4 + facing - 1, 4)]
    defp rotate_robot(%{facing: facing}, 1), do: [facing: rem(facing + 1, 4)]

    defp move_robot([facing: 0] = facing, %{position: {x, y}}),
      do: [{:position, {x, y - 1}} | facing]

    defp move_robot([facing: 1] = facing, %{position: {x, y}}),
      do: [{:position, {x + 1, y}} | facing]

    defp move_robot([facing: 2] = facing, %{position: {x, y}}),
      do: [{:position, {x, y + 1}} | facing]

    defp move_robot([facing: 3] = facing, %{position: {x, y}}),
      do: [{:position, {x - 1, y}} | facing]

    defp set_status(robot, state), do: [{:stopped, state == :stop} | robot]

    defp align(robot, grid, memory), do: do_loop(grid, memory, robot)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop()
      |> Map.keys()
      |> Enum.count()
    end

    defp prepare_loop(intcode) do
      grid = Map.new()
      memory = Map.new(program: intcode, index: 0, base: 0)
      robot = Map.new(position: {0, 0}, facing: 0, stopped: false)
      Common.do_loop(grid, memory, robot)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: [binary()]
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop()
      |> draw()
    end

    defp draw(grid) do
      {{{minx, _}, _}, {{maxx, _}, _}} = Enum.min_max_by(grid, &elem(elem(&1, 0), 0))
      {{{_, miny}, _}, {{_, maxy}, _}} = Enum.min_max_by(grid, &elem(elem(&1, 0), 1))

      for y <- miny..maxy do
        list =
          for x <- minx..maxx do
            value = Map.fetch(grid, {x, y})
            replace(value)
          end

        Enum.join(list)
      end
    end

    defp replace({_, 1}), do: "X"
    defp replace(_), do: " "

    defp prepare_loop(intcode) do
      grid = Map.new([{{0, 0}, 1}])
      memory = Map.new(program: intcode, index: 0, base: 0)
      robot = Map.new(position: {0, 0}, facing: 0, stopped: false)
      Common.do_loop(grid, memory, robot)
    end
  end
end
