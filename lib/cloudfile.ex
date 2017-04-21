defmodule Cloudfile do
  @moduledoc """
  Library that creates a unified API for working with files on different storage
  devices.

  Currently supporting:

  * local storage - "/path/to/some/file"
  * Google Cloud Storage - "gcs://path/to/some/file"
  * REST endpoints - "http://google.com/path/to/some/file"

  """

  alias Cloudfile.Driver.HTTP, as: HTTP
  alias Cloudfile.Driver.GCS, as: GCS
  alias Cloudfile.Driver.Local, as: Local

  alias Cloudfile.Utils, as: Utils

  @type uri :: String.t
  @type path :: String.t
  @type reason :: String.t
  @type protocol :: :http | :gcs | :local


  @doc """
  Returns `{:ok, binary}` where `binary` is the contents of `path` and
  `{:error, reason}` if an error occurs. Implementation details for each driver
  should be documented in its module.

  """
  @spec read(uri) :: {:ok, binary} | {:error, reason}
  def read(uri) when is_binary(uri) do
    case Utils.extract_protocol(uri) do
      {:http, url}   -> HTTP.read(url)
      {:gcs, path}   -> GCS.read(url)
      {:local, path} -> Local.read(path)
    end
  end


  @doc """
  Returns a binary with the contents of the given filename or raises a
  `File.Error` when an error occurs.

  """
  @spec read!(uri) :: binary | no_return
  def read!(uri) when is_binary(uri) do
    with {:ok, content} <- read(uri) do
      content
    else
      {:error, reason} ->
        raise File.Error, reason: reason, action: "read file", path: uri
    end
  end


  @doc """
  Writes `content` to the file pointed to by `uri`. Implementation details for
  each driver should be documented in its module.

  """
  @spec write(uri, binary) :: :ok | {:error, reason}
  def write(uri, content) when is_binary(uri) and is_binary(content) do
    case Utils.extract_protocol(uri) do
      {:http, url}   -> HTTP.write(url, content)
      {:gcs, path}   -> GCS.write(url, content)
      {:local, path} -> Local.write(path, content)
    end
  end


  @doc """
  Writes `content` to the file pointed to by `uri`. Returns `:ok` if successful.
  Raises a `File.Error` otherwise.

  """
  @spec write!(uri, binary) :: :ok | no_return
  def write!(uri, content) when is_binary(uri) and is_binary(content) do
    with :ok <- write(uri, content) do
      :ok
    else
      {:error, reason} ->
        raise File.Error, reason: reason, action: "write file", path: uri
    end
  end


  @doc """
  Attempts to delete the file pointed to by `uri`.

  """
  @spec rm(uri) :: :ok | {:error, reason}
  def rm(uri) do
    case Utils.extract_protocol(uri) do
      {:http, url}   -> HTTP.rm(url)
      {:gcs, path}   -> GCS.rm(url)
      {:local, path} -> Local.rm(path)
    end
  end


  @doc """
  Shares the behavior of `rm/1`. This function raises on an error, however.

  """
  @spec rm!(uri) :: :ok | no_return
  def rm!(uri) do
    with :ok <- rm(uri) do
      :ok
    else
      {:error, reason} ->
        raise File.Error, reason: reason, action: "remove file", path: uri
    end
  end


end
