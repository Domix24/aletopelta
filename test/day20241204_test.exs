defmodule AletopeltaTest.Day20241204 do
  
  use AletopeltaTest.Custom
  @filename "2024/day/4/input"

  defp get_input() do
    response = Tesla.get(AletopeltaTest.create_client(), @filename)

    case response do
      {:ok, %Tesla.Env{status: 200, body: result}} -> result |> String.split("\n")
      {:ok, %Tesla.Env{status: status_code}} ->
        raise "Request failed with status code: #{status_code}"
      {:error, reason} ->
        raise "Request failed: #{inspect(reason)}"
    end
  end

  test "part1 is loaded" do
    input = get_input()

    assert Aletopelta.Day20241204.Part1.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241204)[:part1])
  end

  test "part2 is loaded" do
    input = get_input()

    assert Aletopelta.Day20241204.Part2.execute(input) == String.to_integer(Application.get_env(:aletopelta, :day20241204)[:part2])
  end
end
