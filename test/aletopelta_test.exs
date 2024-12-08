defmodule AletopeltaTest do
  use ExUnit.Case
  use Tesla
  doctest Aletopelta

  defp create_client() do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, Application.get_env(:aletopelta, :web)[:tesla_complete_url]},
      {Tesla.Middleware.Headers, [{"Cookie", Application.get_env(:aletopelta, :web)[:session_token]}]}
    ]) 
  end

  def get_input!(filename) do
    response = Tesla.get(create_client(), filename)

    case response do
      {:ok, %Tesla.Env{status: 200, body: result}} -> result
      {:ok, %Tesla.Env{status: status_code, body: result}} ->
        raise "Request failed with status code: #{status_code}, #{result}"
      {:error, reason} ->
        raise "Request failed: #{inspect(reason)}"
    end
  end

  test "greets the world" do
    assert Aletopelta.hello() == :world
  end
end
