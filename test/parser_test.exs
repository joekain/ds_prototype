defmodule ParserTest do
  use ExUnit.Case

  def mock_tweet do
    %ExTwitter.Model.Tweet{
      contributors: nil,
      coordinates: nil,
      created_at: "Tue Aug 04 23:21:03 +0000 2015",
      entities: %{
        hashtags: [%{indices: [25, 36], text: "elixirlang"}],
        symbols: [],
        urls: [
          %{
            display_url: "buff.ly/1LYD0tp",
            expanded_url: "http://buff.ly/1LYD0tp", indices: '\'=',
            url: "http://t.co/kfLrRZJ1cI"
          }
        ],
        user_mentions: []
      },
      favorite_count: 1,
      favorited: false,
      geo: nil,
      id: 628707248206925824,
      id_str: "628707248206925824",
      in_reply_to_screen_name: nil,
      in_reply_to_status_id: nil,
      in_reply_to_status_id_str: nil,
      in_reply_to_user_id: nil,
      in_reply_to_user_id_str: nil,
      lang: "en",
      place: nil,
      retweet_count: 0,
      retweeted: false,
      source: "<a href=\"http://bufferapp.com\" rel=\"nofollow\">Buffer</a>",
      text: "Read about how I learned #elixirlang - http://t.co/kfLrRZJ1cI",
      truncated: false
    }
  end

  test "It can extract the text" do
    expected_text = "Expected"
    test_data = %ExTwitter.Model.Tweet{ text: expected_text }
    assert Parser.text(test_data) == expected_text
  end

  test "It can extract URLs" do
    assert Parser.urls(mock_tweet) == ["http://buff.ly/1LYD0tp"]
  end
end
