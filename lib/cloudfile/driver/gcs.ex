defmodule Cloudfile.Driver.GCS do
  @moduledoc """
  Implements the `Cloudfile.Driver` behaviour for Google Cloud Storage.

  """

  @behaviour Cloudfile.Driver

  alias GCloudex.CloudStorage.Client, as: Storage
  alias Cloudfile.Driver.GCS.Utils, as: GCSUtils


  @spec supported_schemes :: [Cloudfile.scheme]
  def supported_schemes, do: ["gcs"]


  @doc """
  Reads the file specified by `path`.

  """
  @spec read(Cloudfile.uri) :: {:ok, binary} | {:error, Cloudfile.reason}
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
  @spec write(Cloudfile.uri, binary) :: :ok | {:error, Cloudfile.reason}
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
  @spec rm(Cloudfile.uri) :: :ok | {:error, Cloudfile.reason}
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
