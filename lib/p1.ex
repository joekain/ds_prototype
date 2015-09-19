defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  def stream do
    Fetcher.fetch
    |> Stream.flat_map(fn x -> Parser.urls(x) end)
    |> Stream.map(fn x -> Unshortener.expand(x) end)
  end
end
