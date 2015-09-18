defmodule FetcherSingleTest do
  use ExUnit.Case

  test "it can fetch the specific tweet" do
    assert FetcherSingle.fetch |> Map.get(:text)  == "Read about how I learned #elixirlang - http://t.co/kfLrRZJ1cI"
  end
end
