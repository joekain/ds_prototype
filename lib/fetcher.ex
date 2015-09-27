defmodule Fetcher do
  @spec fetch :: Enumerable.t
  def fetch do
    Decoupler.run_lazy(fn -> ExTwitter.stream_filter(track: "apple") end)
  end
end
