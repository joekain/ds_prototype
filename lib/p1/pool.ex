defmodule P1.Pool do
  defp stream do
    Fetcher.fetch
    |> Stream.flat_map(fn tweet -> Parser.urls(tweet) end)
    |> PoolUtil.map_through_pool(P1.pool_name)
  end

  def run do
    stream |> Stream.map(fn x -> IO.inspect x end) |> Enum.take(10) |> Enum.to_list
  end
end
