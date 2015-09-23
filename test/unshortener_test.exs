defmodule UnshortenerTest do
  use ExUnit.Case

  test "it can unshorten a test URL" do
    assert Unshortener.expand("http://buff.ly/1LYD0tp") == "http://learningelixir.joekain.com/how-I-learned-elixir/?utm_content=buffer9a56c&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer"
  end

  test "it passes through normal URLs" do
    assert Unshortener.expand("http://www.google.com") == "http://www.google.com"
  end

  test "it reports error for bad URLs" do
    assert Unshortener.expand("http://garbage.example.com") == :error
  end

  test "it can unshorten double shortened URLs" do
    assert Unshortener.expand("http://t.co/kfLrRZJ1cI") == "http://learningelixir.joekain.com/how-I-learned-elixir/?utm_content=buffer9a56c&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer"
  end

  test "it can unshorten http://ow.ly/ScJ9I" do
    assert Unshortener.expand("http://ow.ly/ScJ9I") == "http://www.amazon.fr/gp/product/B00XY4ZIRE/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1642&creative=6746&creativeASIN=B00XY4ZIRE&linkCode=as2&tag=petbuzmar-21"
  end

  test "it can unshorten http://fb.me/6RK0qYjJI" do
    assert Unshortener.expand("http://fb.me/6RK0qYjJI") == "https://www.facebook.com/photo.php?fbid=863512007031067"
  end
end
