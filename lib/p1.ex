defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  defp start_task(record) do
    Task.async(fn -> Unshortener.expand(record) end)
  end

  defp start_tasks(records) do
    records |> Enum.map(&start_task/1)
  end

  defp await_tasks(list_of_tasks) do
    list_of_tasks
    |> Enum.map(fn task -> Task.await(task, :infinity) end)
  end

  def stream do
    Fetcher.fetch  # Stream of Tweets
    |> Stream.flat_map(&Parser.urls(&1))
    |> Stream.chunk(5)  # Stream of lists with 5 Tweets each
    |> Stream.flat_map(&start_tasks/1) # Stream of `Tasks`
    |> Stream.chunk(5)  # Stream of lists with 5 `Tasks` each
    |> Stream.flat_map(&await_tasks/1) # Stream of resulting URLs
  end
end
