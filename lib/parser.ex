defmodule Parser do
  @spec text(ExTwitter.Model.Tweet.t) :: String.t
  def text(tweet) do
    tweet |> Map.get(:text)
  end

  @spec urls(ExTwitter.Model.Tweet.t) :: [ String.t ]
  def urls(tweet) do
    tweet
    |> Map.get(:entities)
    |> Map.get(:urls)
    |> Enum.map(&Map.get(&1, :expanded_url))
  end
end
