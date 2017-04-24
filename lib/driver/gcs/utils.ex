defmodule Cloudfile.Driver.GCS.Utils do
  @moduledoc """
  Hosts utility functions to support Google Cloud Storage business logic.

  """

  import SweetXml

  @type res :: {:ok, HTTPoison.Response.t}


  @doc """
  Splits a GCS URI into its bucket and object path.

  # Example

    iex> alias Cloudfile.Driver.GCS.Utils
    ...> Utils.parse_path("gcs://bucket/path/to/file.txt")
    %{bucket: "bucket", path: "path/to/file.txt"}

  """
  @spec parse_path(Cloudfile.uri) :: {String.t, String.t}
  def parse_path(uri) do
    ["gcs:", bucket | rest] = Path.split(uri)

    {bucket, Enum.join(rest, "/")}
  end


  @doc """
  Convenience function to assist in processing successful GCS requests.

  """
  @spec response_successful?(HTTPoison.Response.t) :: boolean
  def response_successful?(%HTTPoison.Response{status_code: code}) do
    code >= 200 and code < 300
  end


  @doc """
  Converts an HTTPoison response from GCS to a `:file.posix` error code.

  """
  @spec to_posix(HTTPoison.Response.t) :: :file.posix
  def to_posix(res) do
    case extract_error_code(res) do
      "NoSuchBucket" -> :enotdir
      "NoSuchKey"    -> :enoent
      key -> {:unrecognized_error, key}
    end
  end

  @spec extract_error_code(HTTPoison.Response.t) :: String.t
  defp extract_error_code(res) do
    res.body
    |> xpath(~x"//Code/text()"s)
  end



end
