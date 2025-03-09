defmodule Aletopelta.Year2024.Day14 do
  @moduledoc """
  Day 14 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """
    defmodule Position do
      @moduledoc """
      Position
      """
      defstruct [:x, :y]
    end

    defmodule Velocity do
      @moduledoc """
      Velocity
      """
      defstruct [:x, :y]
    end

    defmodule Robot do
      @moduledoc """
      Robot
      """
      defstruct [:position, :velocity, :quadrant]
    end

    defmodule Dimensions do
      @moduledoc """
      Dimensions
      """
      defstruct [:height, :width]
    end

    defmodule Quadrant do
      @moduledoc """
      Quadrant
      """
      defstruct [:topleft, :bottomright]
    end

    @pattern_pv ~r/p=(\d+),(\d+) v=([-+]?\d+),([-+]?\d+)/

    def parse_lines([]), do: []
    def parse_lines([line | rest]) do
      line = line
      |> parse_line

      [line | rest
      |> parse_lines]
      |> Enum.filter(&(&1 != nil))
    end

    defp parse_line(""), do: nil
    defp parse_line(line) do
      [_, px, py, vx, vy] = @pattern_pv
      |> Regex.run(line)

      [px, py, vx, vy] = [px, py, vx, vy]
      |> Enum.map(fn numberstring ->
        numberstring
        |> String.to_integer
      end)

      %Robot{position: %Position{x: px, y: py}, velocity: %Velocity{x: vx, y: vy}}
    end

    def simulate([], _, _), do: []

    def simulate([first | rest], map, simulations) do
      first = update_position(first, map, simulations)
      [first | simulate(rest, map, simulations)]
    end

    defp update_position(robot, map, simulations) do
      x = calculate_coordinate(robot.position.x, robot.velocity.x, simulations, map.width)
      y = calculate_coordinate(robot.position.y, robot.velocity.y, simulations, map.height)
      %{robot | position: %{robot.position | x: x, y: y}}
    end

    defp calculate_coordinate(position, velocity, simulations, limit) do
      rem(rem(position + velocity * simulations, limit) + limit, limit)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    def execute(input) do
      map = %Common.Dimensions{height: 103, width: 101}
      input
      |> Common.parse_lines
      |> Common.simulate(map, 100)
      |> assign_quadrants(map)
      |> Enum.reduce(1, fn {_, count}, acc -> acc * count end)
    end

    defp assign_quadrants(robots, map) do
      robots
      |> Enum.map(&determine_quadrant(&1, map))
      |> Enum.filter(&(&1.quadrant))
      |> Enum.reduce(%{}, fn robot, acc ->
        acc
        |> Map.update(robot.quadrant, 1, &(&1 + 1))
      end)
    end

    defp determine_quadrant(robot, map) do
      quadrants = define_quadrants(map)

      index = quadrants
      |> Enum.find_index(fn quadrant ->
        robot.position.x > quadrant.topleft.x and robot.position.x < quadrant.bottomright.x and
        robot.position.y > quadrant.topleft.y and robot.position.y < quadrant.bottomright.y
      end)

      %{robot | quadrant: index}
    end

    defp define_quadrants(map) do
      [
        %Common.Quadrant{topleft: %Common.Position{x: -1, y: -1}, bottomright: %Common.Position{x: div(map.width, 2), y: div(map.height, 2)}},
        %Common.Quadrant{topleft: %Common.Position{x: div(map.width, 2), y: -1}, bottomright: %Common.Position{x: map.width, y: div(map.height, 2)}},
        %Common.Quadrant{topleft: %Common.Position{x: -1, y: div(map.height, 2)}, bottomright: %Common.Position{x: div(map.width, 2), y: map.height}},
        %Common.Quadrant{topleft: %Common.Position{x: div(map.width, 2), y: div(map.height, 2)}, bottomright: %Common.Position{x: map.width, y: map.height }}
      ]
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    def execute(input) do
      map = %Common.Dimensions{height: 103, width: 101}
      input
      |> Common.parse_lines
      |> run_simulations(map)
    end

    defp run_simulations(robots, map) do
      robots
      |> run_simulations(map, 0)
    end

    defp run_simulations(robots, map, step) do
      case simulate(robots, map, step) do
        true -> robots
        |> run_simulations(map, step + 1)
        false -> step
      end
    end

    defp simulate(robots, map, step) do
      robots
      |> Common.simulate(map, step)
      |> Enum.group_by(&(&1.position), &(&1))
      |> Enum.any?(fn {_, robots} -> length(robots) > 1 end)
    end
  end
end
