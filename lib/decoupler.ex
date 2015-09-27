defmodule Decoupler do
  def process(lazy_input_stream, f, depth) do
    {:ok, queue} = BlockingQueue.start_link(depth)

    spawn_link(fn ->
      lazy_input_stream.()
      |> Stream.map(f)
      |> Enum.each(fn x -> BlockingQueue.push(queue, x) end)
    end)

    Stream.repeatedly(fn -> BlockingQueue.pop(queue) end)
  end


  def run_lazy(lazy_input_stream) do
    process(lazy_input_stream, fn x -> x end, 1)
  end

  def run(input_stream) do
    run_lazy(fn -> input_stream end)
  end
end
