defmodule Unshortener do
  @spec expand(String.t) :: String.t
  def expand(short) do
    try do
      case HTTPotion.head(short) do
        %HTTPotion.Response{headers: headers, status_code: 301} -> headers[:Location]
        %HTTPotion.Response{headers: headers, status_code: success} when 200 <= success and success < 300 -> short
      end
    rescue
      _ -> :error
    end
  end
end
