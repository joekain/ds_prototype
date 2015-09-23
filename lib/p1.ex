defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  defp start_task(record) do
    Task.async(fn ->
      Parser.urls(record) |> Enum.map(fn x ->
        Unshortener.expand(x)
      end)
    end)
  end

  defp await_tasks(list_of_tasks) do
    list_of_tasks
    |> Enum.map(fn task -> Task.await(task, :infinity) end)
  end

  def stream do
    Fetcher.fetch  # Stream of Tweets
    |> Stream.map(fn x -> start_task(x) end)  # Stream of `Task`s each processing a Tweet
    |> Stream.chunk(5)  # Stream of lists with 5 `Tasks` each
    |> Stream.flat_map(&await_tasks/1) # Stream of resulting URLs
  end
end
