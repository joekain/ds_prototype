defmodule P1Test do
  use ExUnit.Case

  test "it should fetch a tweet and extract the URL" do
    assert P1.run == ["http://learningelixir.joekain.com/how-I-learned-elixir/?utm_content=buffer9a56c&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer"]
  end

  test "it should just stream out URLs from the firehose" do
    stream = P1.stream |> Stream.map(fn x -> IO.puts x end) |> Enum.take(10) |> Enum.to_list
    Enum.to_list(stream)
  end
end
