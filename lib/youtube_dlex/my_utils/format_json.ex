defmodule YoutubeDlex.Utils.FormatJson do
  # @escaping_sequences [
  #   "\"",
  #   "'",
  #   "`",
  #   # RegeEx
  #   "/"
  # ]

  # @escaping_sequences [
  #   %{start_end: "\""},
  #   %{start_end: "'"},
  #   %{start_end: "`"},
  #   # RegeEx
  #   %{start_end: "/", startPrefix: ~r/(^|[[{:;,\/])\s?$/}
  # ]

  def call(mixed_json) do
    String.slice(mixed_json, 0, String.length(mixed_json) - 1)
  end

  # defp loop(json, i, open_char, opened_count) do
  # end

  # defp get_string_end_index(string, opened_char, i) do
  #   cur_char = String.at(string, i)

  #   cond do
  #     cur_char == opened_char -> i
  #     cur_char == "\\" -> get_string_end_index(string, opened_char, i + 2)
  #     true -> get_string_end_index(string, opened_char, i + 1)
  #   end
  # end

  # def get_open_close(""), do: {:error, "Invalid JSON"}

  # def get_open_close(mixed_json) do
  #   case String.at(mixed_json, 0) do
  #     "[" ->
  #       %{open: "[", close: "]"}

  #     "{" ->
  #       %{open: "{", close: "}"}

  #     char when is_bitstring(char) ->
  #       {:error, "Can't cut unsupported JSON (need to begin with [ or { ) but got: #{char}"}

  #     _ ->
  #       {:error, "Error cutting the JSON"}
  #   end
  # end
end
