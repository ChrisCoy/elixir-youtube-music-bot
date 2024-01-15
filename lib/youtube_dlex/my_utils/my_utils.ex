defmodule YoutubeDlex.Utils.MyUtils do
  alias YoutubeDlex.Utils.Between
  alias YoutubeDlex.Utils.FormatJson

  defdelegate between(haystack, left, right), to: Between, as: :call
  defdelegate format_json(json), to: FormatJson, as: :call
end
