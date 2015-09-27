defmodule Processor do
  defmodule Subprocessor do
    use ExActor.GenServer

    defstart start_link(f, x), do: initial_state(f.(x))
    defcall get, state: state, do: reply(state)
    defcast stop, do: stop_server(:normal)
  end


  use ExActor.GenServer

  defp process(x, f) do
    {:ok, pid} = Subprocessor.start_link(f, x)
    pid
  end

  defstart start_link(lazy_input_stream, f) do
    {:ok, queue} = BlockingQueue.start_link(5)

    spawn_link(fn ->
      lazy_input_stream.()
      |> Stream.map(fn x -> process(x, f) end)
      |> Enum.each(fn x -> BlockingQueue.push(queue, x) end)
    end)

    initial_state(queue)
  end

  defcall next, state: queue do
    sub = BlockingQueue.pop(queue)
    result = Subprocessor.get(sub)
    Subprocessor.stop(sub)

    reply(result)
  end

  def map(input_stream, f) do
    {:ok, pid} = start_link(input_stream, f)
    Stream.repeatedly(fn -> next(pid) end)
  end
end
