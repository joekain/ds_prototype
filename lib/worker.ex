defmodule Worker do
  use ExActor.GenServer

  defstart start_link(_), do: initial_state(0)

  defcast work(queue, x) do
    BlockingQueue.push(queue, {self, x + 1})
    new_state(0)
  end
end
