defmodule P1 do
  def run do
    [ FetcherSingle.fetch |> Parser.urls |> Unshortener.expand ]
  end

  def lazy_urls do
  end

  def stream do
    Fetcher.fetch
    |> Stream.flat_map(fn tweet -> Parser.urls(tweet) end)
    |> Processor.map(fn url -> Unshortener.expand(url) end)
  end

  def stream_run do
    stream |> Stream.map(fn x -> IO.inspect x end) |> Enum.take(10) |> Enum.to_list
  end

  def pool_name, do: :p1_pool

  defp poolboy_config do
    [
      {:name, {:local, pool_name}},
      {:worker_module, Worker},
      {:size, 5},
      {:max_overflow, 10}
    ]
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config(), [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: P7.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
