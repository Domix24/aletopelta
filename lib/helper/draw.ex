defmodule Aletopelta.Helper do
  defmodule Draw do
    def draw_map(map) do
      {max_x, max_y} = Enum.reduce(map, {0, 0}, fn {{x, y}, _}, {max_x, max_y} ->
        {max(x, max_x), max(y, max_y)}
      end)

      for y <- 0..max_y, x <- 0..max_x do
        coordinate = {x, y}

        sign = IO.write Map.fetch!(map, coordinate)

        color = case sign do
          1 -> IO.ANSI.green <> IO.ANSI.blink_slow # main
          2 -> IO.ANSI.red <> IO.ANSI.blink_off # walls
          3 -> IO.ANSI.magenta <> IO.ANSI.blink_off # void
          4 -> IO.ANSI.yellow <> IO.ANSI.blink_off # other
          5 -> IO.ANSI.cyan <> IO.ANSI.blink_off # other
        end

        IO.write color <> sign
        if x == max_x, do: IO.puts ""
      end
    end
  end
end
