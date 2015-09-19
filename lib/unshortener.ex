defmodule Unshortener do
  defp location(headers) do
    case Keyword.get(headers, :Location) do
      nil      -> Keyword.get(headers, :location)
      location -> location
    end
  end

  @spec expand(String.t) :: String.t
  def expand(short) do
    try do
      case HTTPotion.head(short) do
        %HTTPotion.Response{headers: headers, status_code: 301} -> location(headers) |> expand
        %HTTPotion.Response{headers: headers, status_code: success} when 200 <= success and success < 300 -> short
      end
    rescue
      _ -> :error
    end
  end
end
