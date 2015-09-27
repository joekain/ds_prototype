defmodule Processor do
  use ExActor.GenServer

  defstart start_link(input_stream, f) do
    {:ok, queue} = BlockingQueue.start_link(5)

    spawn_link(fn ->
      input_stream
      |> Stream.map(f)
      |> Stream.map(fn x -> BlockingQueue.push(queue, x) end)
      |> Stream.run
    end)

    initial_state(queue)
  end

  defcall next, state: queue, do: reply(BlockingQueue.pop(queue))

  def map(input_stream, f) do
    {:ok, pid} = start_link(input_stream, f)
    Stream.repeatedly(fn -> next(pid) end)
  end
end
