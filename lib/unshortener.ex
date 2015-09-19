defmodule Unshortener do

  # Field name "location" is case insensitive in HTTP so use downcase
  defp canonical_field_name(key) do
    key
    |> Atom.to_string
    |> String.downcase
  end

  defp location(headers) do
    {_key, value} = Enum.find(headers, nil, fn {key, value} ->
      canonical_field_name(key) == "location"
    end)

    value
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
