defmodule Fetcher do
  @spec fetch :: Enumerable.t
  def fetch do
    ExTwitter.stream_filter(track: "apple")
    |> Stream.flat_map(fn x -> Parser.urls(x) end)
    |> Stream.map(fn x -> Unshortener.expand(x) end)
  end
end
