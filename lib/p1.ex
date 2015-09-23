defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  defp start_task(record) do
    Task.async(fn ->
      Parser.urls(record) |> Enum.map(fn x -> Unshortener.expand(x) end)
    end)
  end

  def stream do
    Fetcher.fetch  # Stream of tweets
    |> Stream.map(fn x -> start_task(x) end)  # Stream of `Task`s
    |> Stream.flat_map(fn x -> Task.await(x) end) # Stream of results - arrays of URLs
  end
end
