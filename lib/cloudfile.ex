defmodule Cloudfile do
  @moduledoc """
  Library that creates a unified API for working with files on different storage
  devices.

  Currently supporting:

  * local storage - "/path/to/some/file"
  * Google Cloud Storage - "gcs://path/to/some/file"
  * REST endpoints - "http://google.com/path/to/some/file"

  """

  @drivers [
    Cloudfile.Driver.Local,
    Cloudfile.Driver.HTTP,
    Cloudfile.Driver.GCS,
  ]


  @type uri :: String.t
  @type scheme :: String.t | nil
  @type path :: String.t
  @type reason :: String.t


  def init do
    @drivers
    |> Enum.each(&DriverRegistry.register/1)
  end


  @doc """
  Returns `{:ok, binary}` where `binary` is the contents of `path` and
  `{:error, reason}` if an error occurs. Implementation details for each driver
  should be documented in its module.

  """
  @spec read(uri) :: {:ok, binary} | {:error, reason}
  def read(uri) when is_binary(uri), do: apply_driver(uri, :read, [uri])


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
  def write(uri, content) when is_binary(uri) and is_binary(content), do:
  apply_driver(uri, :write, [uri, content])


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
  def rm(uri), do: apply_driver(uri, :rm, [uri])


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

  defp apply_driver(uri, action, args) do
    scheme = get_scheme(uri)

    case DriverRegistry.get_driver(scheme) do
      nil    -> raise("No registered drivers match the provided URI: \"#{uri}\"")
      driver -> apply(driver, action, args)
    end
  end

  @spec get_scheme(Cloudfile.uri) :: Cloudfile.scheme
  defp get_scheme(uri) do
    case URI.parse(uri) do
      %URI{scheme: nil} -> nil
      %URI{scheme: x}   -> String.downcase(x)
    end
  end


end
