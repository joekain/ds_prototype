defmodule Fetcher do
  @spec fetch :: Enumerable.t
  def fetch do
    ExTwitter.stream_filter(track: "apple")
  end
end
