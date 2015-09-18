defmodule FetcherSingle do
  @spec fetch :: String.t
  def fetch do
    ExTwitter.show(628707248206925824)
  end
end
