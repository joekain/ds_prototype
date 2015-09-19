defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  def stream do
    Fetcher.fetch #|> Parser.urls |> Unshortener.expand
  end
end
