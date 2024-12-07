defmodule AletopeltaTest do
  use ExUnit.Case
  use Tesla
  doctest Aletopelta

  def create_client() do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, Application.get_env(:aletopelta, :web)[:tesla_complete_url]},
      {Tesla.Middleware.Headers, [{"Cookie", Application.get_env(:aletopelta, :web)[:session_token]}]}
    ])      
  end

  test "greets the world" do
    assert Aletopelta.hello() == :world
  end
end
