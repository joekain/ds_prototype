defmodule Unshortener do

  # Field name "location" is case insensitive in HTTP so use downcase
  defp canonical_field_name(key) do
    key
    |> Atom.to_string
    |> String.downcase
  end

  defp location(headers) do
    {_key, value} = Enum.find(headers, nil, fn {key, _value} ->
      canonical_field_name(key) == "location"
    end)

    value
  end

  defp is_special_case(location) do
    location in [
      "https://www.facebook.com/unsupportedbrowser"  # Facebook redirects HTTPotion to the unsupported browser page
    ]
  end

  defp handle_redirect(short, headers) do
    new_location = location(headers)
    case is_special_case(new_location) do
      :true -> short
      :false -> expand(new_location)
    end
  end

  @spec expand(String.t) :: String.t
  def expand(short) do
    try do
      case HTTPotion.head(short) do
        %HTTPotion.Response{headers: headers, status_code: redirect} when 301 <= redirect and redirect <= 302 ->
          handle_redirect(short, headers)
        # Assumes all shortening services respond to HEAD and that target URLs may not.
        # In that case expansion is done.
        %HTTPotion.Response{headers: _headers, status_code: 405} -> short
        %HTTPotion.Response{headers: _headers, status_code: success} when 200 <= success and success < 300 -> short
      end
    rescue
      _ -> :error
    end
  end
end
