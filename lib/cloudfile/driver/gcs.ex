defmodule CloudFile.Driver.GCS do
  @moduledoc """
  Implements the `CloudFile.Driver` behaviour for Google Cloud Storage.

  """

  @behaviour CloudFile.Driver

  alias GCloudex.CloudStorage.Client, as: Storage
  alias CloudFile.Driver.GCS.Utils, as: GCSUtils


  @spec supported_schemes :: [CloudFile.scheme]
  def supported_schemes, do: ["gcs"]


  @doc """
  Reads the file specified by `path`.

  """
  @spec read(CloudFile.uri) :: {:ok, binary} | {:error, CloudFile.reason}
  def read(path) do
    {bucket, filepath} =
      GCSUtils.parse_path(path)

    with {:ok, res} <- Storage.get_object(bucket, filepath) do
      case GCSUtils.response_successful?(res) do
        true  -> {:ok, res.body}
        false -> {:error, GCSUtils.to_posix(res)}
      end
    else
      {:error, _reason} = err -> err
    end
  end


  @doc """
  Writes a file to Google Cloud Storage. The `GCloudex.CloudStorage` API expects
  a filepath as its `content` parameter. To circumvent this API restriction a
  temporary file is created, referenced, and afterwards removed.

  """
  @spec write(CloudFile.uri, binary) :: :ok | {:error, CloudFile.reason}
  def write(path, content) do
    {bucket, filepath} =
      GCSUtils.parse_path(path)

    with {:ok, res} <- Storage.request_query(:put, bucket, [], content, filepath) do
      case GCSUtils.response_successful?(res) do
        true  -> :ok
        false -> {:error, GCSUtils.to_posix(res)}
      end
    else
      {:error, _reason} = err -> err
    end
  end


  @doc """
  Removes the file specified by `path`.

  """
  @spec rm(CloudFile.uri) :: :ok | {:error, CloudFile.reason}
  def rm(path) do
    {bucket, filepath} =
      GCSUtils.parse_path(path)

    with {:ok, res} <- Storage.delete_object(bucket, filepath) do
      case GCSUtils.response_successful?(res) do
        true  -> :ok
        false -> {:error, GCSUtils.to_posix(res)}
      end
    else
      {:error, _reason} = err -> err
    end
  end


end
