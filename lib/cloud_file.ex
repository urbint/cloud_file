defmodule CloudFile do
  @moduledoc """
  Library that creates a unified API for working with files on different storage
  devices.

  Currently supporting:

  * local storage - "/path/to/some/file"
  * Google Cloud Storage - "gcs://path/to/some/file"
  * REST endpoints - "http://google.com/path/to/some/file"

  """

  alias CloudFile.DriverRegistry, as: Drivers

  @type uri :: String.t
  @type scheme :: String.t | nil
  @type path :: String.t
  @type reason :: String.t


  @doc """
  Returns `{:ok, binary}` where `binary` is the contents of `path` and
  `{:error, reason}` if an error occurs. Implementation details for each driver
  should be documented in its module.

  """
  @spec read(uri) :: {:ok, binary} | {:error, reason}
  def read(uri) when is_binary(uri), do: apply_driver(uri, :read, [uri])


  @doc """
  Returns a binary with the contents of the given filename or raises a
  `CloudFile.Error` when an error occurs.

  """
  @spec read!(uri) :: binary | no_return
  def read!(uri) when is_binary(uri) do
    with {:ok, content} <- read(uri) do
      content
    else
      {:error, reason} ->
        raise CloudFile.Error, reason: reason, action: "read file", path: uri
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
  Raises a `CloudFile.Error` otherwise.

  """
  @spec write!(uri, binary) :: :ok | no_return
  def write!(uri, content) when is_binary(uri) and is_binary(content) do
    with :ok <- write(uri, content) do
      :ok
    else
      {:error, reason} ->
        raise CloudFile.Error, reason: reason, action: "write file", path: uri
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
        raise CloudFile.Error, reason: reason, action: "remove file", path: uri
    end
  end


  @doc """
  Returns `true` if the given `path` exists. Files refer to anything that Unix would refer to as a
  file. This includes:

  * files
  * directories
  * sockets
  * symlinks
  * named pipes (i.e. `/dev/null`)
  * device files

  This spec borrowed from `File.exists?/1` in the Elixir stdlib. Refer to that documentation for
  additional information.

  """
  @spec exists?(uri) :: boolean
  def exists?(uri), do: apply_driver(uri, :exists?, [uri])


  @doc """
  Returns the list of files in the given directory. Absolute and relative paths work for some
  drivers but relative paths might not make sense for certain drivers.

  """
  @spec ls(uri) :: {:ok, [binary]} | {:error, reason}
  def ls(uri), do: apply_driver(uri, :ls, [uri])


  @doc """
  The same as `ls/1` but raise `CloudFile.Error` in the case of an error.

  """
  @spec ls!(uri) :: [binary]
  def ls!(uri) do
    with {:ok, files} <- rm(uri) do
      files
    else
      {:error, reason} ->
        raise CloudFile.Error, reason: reason, action: "list directory", path: uri
    end
  end


  defp apply_driver(uri, action, args) do
    scheme = get_scheme(uri)

    case Drivers.get_driver(scheme) do
      {:error, reason} -> raise("Error fetching driver for URI: \"#{uri}\": #{reason}")
      {:ok, driver}    -> apply_if_implemented!(driver, action, args)
    end
  end

  defp apply_if_implemented!(driver, action, args) do
    case apply(driver, action, args) do
      {:error, :not_implemented} -> raise("Function `#{to_string(action)}/#{length(args)}` not implemented for driver `#{inspect(driver)}`")
      result -> result
    end
  end

  @spec get_scheme(CloudFile.uri) :: CloudFile.scheme
  defp get_scheme(uri) do
    case URI.parse(uri) do
      %URI{scheme: nil} -> nil
      %URI{scheme: x}   -> String.downcase(x)
    end
  end


end
