defmodule Processor do
  defp process(x, f) do
    {:ok, pid} = Agent.start_link(fn -> f.(x) end)
    pid
  end

  defp post_process(pid) do
    result = Agent.get(pid, fn x -> x end)
    Agent.stop(pid)

    result
  end

  def map(input_stream, f) do
    Decoupler.process(fn -> input_stream end, fn x -> process(x, f) end, 5)
    |> Stream.map(&post_process/1)
  end
end
