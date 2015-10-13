defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  def lazy_urls do
  end

  def stream do
    Fetcher.fetch
    |> Stream.flat_map(fn tweet -> Parser.urls(tweet) end)
    |> Processor.map(fn url -> Unshortener.expand(url) end)
  end

  def stream_run do
    stream |> Stream.map(fn x -> IO.inspect x end) |> Enum.take(10) |> Enum.to_list
  end
end
