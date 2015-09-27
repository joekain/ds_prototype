defmodule Processor do
  defmodule Subprocessor do
    use ExActor.GenServer

    defstart start_link(f, x), do: initial_state(f.(x))
    defcall get, state: state, do: reply(state)
    defcast stop, do: stop_server(:normal)
  end

  defp process(x, f) do
    {:ok, pid} = Subprocessor.start_link(f, x)
    pid
  end

  defp post_process(pid) do
    result = Subprocessor.get(pid)
    Subprocessor.stop(pid)

    result
  end

  def map(input_stream, f) do
    Decoupler.process(fn -> input_stream end, fn x -> process(x, f) end, 5)
    |> Stream.map(&post_process/1)
  end
end
