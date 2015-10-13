defmodule PoolUtil do
  def map_through_pool(enum, pool) do
    {:ok, queue} = BlockingQueue.start_link(:infinity)

    enum
    |> resource(pool, queue)
    |> extract_and_checkin(pool)
  end

  defp resource(enum, pool, queue) do
    Stream.resource(
      fn ->
        spawn_link fn -> stream_through_pool(enum, pool, queue) end
      end,

      fn _ -> {[BlockingQueue.pop(queue)], nil} end,
      fn _ -> true end
    )
  end

  defp stream_through_pool(enum, pool, queue) do
    enum
    |> Stream.map(fn x -> {x, :poolboy.checkout(pool)} end)
    |> Stream.map(fn {x, worker} -> Worker.work(worker, queue, x) end)
    |> Stream.run
  end

  defp extract_and_checkin(stream, pool) do
    Stream.map stream, fn {worker, result} ->
      :poolboy.checkin(pool, worker)
      result
    end
  end
end
