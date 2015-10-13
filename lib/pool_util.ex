defmodule PoolUtil do
  def into(enum, col, opts) do
    pool = opts[:via]
    {:ok, queue} = BlockingQueue.start_link(:infinity)

    enum
    |> resource(pool, queue)
    |> extract_and_checkin(pool)
    |> Stream.into(col, fn x -> x end)
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
    |> Enum.map(fn x -> {x, :poolboy.checkout(pool)} end)
    |> Enum.map(fn {x, worker} -> P7.Worker.work(worker, queue, x) end)
  end

  defp extract_and_checkin(stream, pool) do
    Stream.map stream, fn {worker, result} ->
      :poolboy.checkin(pool, worker)
      result
    end
  end
end
