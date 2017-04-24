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

  @type uri :: String.t
  @type scheme :: String.t | nil
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
    driver =
      find_driver(uri)

    driver.read(uri)
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
    driver =
      find_driver(uri)

    driver.write(uri, content)
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
    driver =
      find_driver(uri)

    driver.rm(uri)
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

  @spec find_driver(uri) :: module
  defp find_driver(uri) do
    %URI{scheme: scheme} = URI.parse(uri)

    DriverRegistry.to_list(registry)
    |> Enum.find(& &1.supported_scheme?(scheme))
  end


end
