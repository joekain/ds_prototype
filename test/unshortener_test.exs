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
end
