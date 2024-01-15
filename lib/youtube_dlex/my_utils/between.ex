defmodule YoutubeDlex.Utils.Between do
  @moduledoc false

  def call("", _left, _right), do: ""
  def call(_haystack, "", _right), do: ""
  def call(_haystack, _left, ""), do: ""

  def call(haystack, %Regex{} = left, right) do
    case index_of(haystack, left) do
      nil ->
        ""

      {index, len} ->
        IO.inspect({index, len})
        left_pos = index + len

        get_till_right(haystack, left_pos, right)
    end
  end

  def call(haystack, left, right) when is_bitstring(left) do
    case index_of(haystack, left) do
      nil ->
        ""

      {index, _len} ->
        left_pos = index + String.length(left)

        get_till_right(haystack, left_pos, right)
    end
  end

  defp get_till_right(haystack, left_pos, right) do
    haystack = String.slice(haystack, left_pos, String.length(haystack))

    case index_of(haystack, right) do
      nil -> ""
      {right_pos, _len} -> String.slice(haystack, 0, right_pos)
    end
  end

  defp index_of(string, %Regex{} = pattern) do
    index_of(string, Regex.run(pattern, string) |> List.last())
  end

  defp index_of(string, pattern) do
    case String.split(string, pattern, parts: 2) do
      [left, _right] -> {String.length(left), String.length(pattern)}
      [_] -> nil
    end
  end
end
