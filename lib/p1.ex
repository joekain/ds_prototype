defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  def lazy_urls do
    Fetcher.fetch |> Stream.flat_map(fn tweet -> Parser.urls(tweet) end)
  end

  def stream do
    Processor.map(&lazy_urls/0, fn url -> Unshortener.expand(url) end)
  end
end
