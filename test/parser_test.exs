defmodule ParserTest do
  use ExUnit.Case

  test "It can extract the text" do
    expected_text = "Expected"
    test_data = %ExTwitter.Model.Tweet{ text: expected_text }
    assert Parser.text(test_data) == expected_text
  end

  test "It can extract the text of a real tweet" do
    assert FetcherSingle.fetch |> Parser.text  == "Read about how I learned #elixirlang - http://t.co/kfLrRZJ1cI"
  end
end
