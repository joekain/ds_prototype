defmodule Parser do
  @spec text(ExTwitter.Model.Tweet.t) :: String.t
  def text(tweet) do
    tweet |> Map.get(:text)
  end
end
