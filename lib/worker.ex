defmodule Worker do
  use ExActor.GenServer

  defstart start_link(_), do: initial_state(0)

  defcast work(queue, url) do
    BlockingQueue.push(queue, {self, Unshortener.expand(url)})
    new_state(0)
  end
end
