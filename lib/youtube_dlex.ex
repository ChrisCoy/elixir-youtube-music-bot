defmodule YoutubeDlex do
  @moduledoc """
  Documentation for `YoutubeDlex`.
  """
  use Tesla

  @chunk_size 1024 * 1024

  plug(Tesla.Middleware.Headers, [
    {"user-agent",
     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"}
  ])

  alias YoutubeDlex.Utils.MyUtils

  def test() do
    page_body = get_page()

    {:ok, json} = find_json(page_body, get_left_regex(), "</script>")

    {url, total_len} = get_audio_url(json["streamingData"])

    stream = File.stream!("teste.mp4", [:write, :binary])

    # Stream.

    # {time, _} = :timer.tc(&stream_download/5, [url, 0, @chunk_size, total_len, stream])

    # IO.inspect(time, label: "time")

    stream_download(url, 0, @chunk_size, String.to_integer(total_len), stream)

    # size_in_megabytes = byte_size(body) / (1024 * 1024)
  end

  # def download_from_url(nil), do: nil

  # def download_from_url(url) do
  #   # Tesla.
  # end

  def stream_download(stream) do
    IO.inspect("#######------########--------#######----")
    Stream.run(stream)
  end

  def stream_download(url, range_start, range_end, total_len, stream) do
    # IO.
    headers = [{"Range", "bytes=#{range_start}-#{range_end}"}]

    IO.inspect("bytes=#{range_start}-#{range_end}::::TOTAL:#{total_len}", label: "range")

    {:ok, %Tesla.Env{} = result} = Tesla.get(url, headers: headers)
    # %{body: body} = Tesla.get(url, headers: headers)

    # IO.inspect(result, label: "result")

    result.body

    new_stream = Stream.into(stream, result.body)

    next_start = range_end + 1

    next_end = next_start + @chunk_size

    if next_end <= total_len do
      stream_download(url, next_start, next_end, total_len, new_stream)
    else
      stream_download(new_stream)
    end
  end

  @doc """
  Hello world.

  ## Examples

      iex> YoutubeDlex.hello()
      :world

  """
  def get_page do
    {:ok, %Tesla.Env{body: body}} = Tesla.get("https://www.youtube.com/watch?v=5FA72gzVoeo")

    body
  end

  def get_audio_url(%{} = response) do
    formats = response["adaptiveFormats"]

    audio_format =
      Enum.find(formats, fn item ->
        match = String.starts_with?(item["mimeType"], "audio/mp4")

        if item["audioQuality"] == "AUDIO_QUALITY_MEDIUM" and match do
          true
        end
      end)

    case audio_format do
      nil -> nil
      format -> {format["url"], format["contentLength"]}
    end
  end

  def find_json(body, left, right) do
    json_str = MyUtils.between(body, left, right)
    json_str = MyUtils.format_json(json_str)

    if json_str == "" do
      {:error, "Could not find json"}
    else
      File.write("assets/json.json", json_str)

      case Jason.decode(json_str) do
        {:ok, json_obj} -> {:ok, json_obj}
        {:error, reason} -> {:error, reason}
      end
    end
  end

  def get_left_regex() do
    # Regex.compile("/\bytInitialPlayerResponse\s*=\s*\{/i")
    ~r/\s*ytInitialPlayerResponse\s*=\s/i
  end
end
