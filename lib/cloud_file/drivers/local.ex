defmodule CloudFile.Drivers.Local do
  @moduledoc """
  Implements the `CloudFile.Driver` behaviour for local storage.

  """

  @behaviour CloudFile.Driver


  @spec init :: :ok | no_return
  def init, do: :ok

  @delegation_warning """
  This function's implementation delegates to the Elixir stdlib's `File`
  module. Please refer the `File` module's documentation for warnings and
  considerations.
  """

  @doc """
  Returns the list of supported schemes for the local storage driver.

  Note: this return value is a singleton list with a value of `nil`. This is by
  design as there is no scheme for a local path in the form of `"/path/to/file"`

  """
  @spec supported_schemes :: [CloudFile.scheme]
  def supported_schemes, do: [nil]


  @doc """
  Reads a file from local storage. #{@delegation_warning}

  """
  @spec read(CloudFile.uri) :: {:ok, binary} | {:error, CloudFile.reason}
  defdelegate read(path), to: File


  @doc """
  Writes to local storage. Essentially a wrapper around the Elixir stdlib `File`
  module. Heed the warning defined in the `File.write/3` documentation regarding
  multiple sequential fs writes.

  """
  @spec write(CloudFile.uri, binary) :: :ok | {:error, CloudFile.reason}
  def write(path, content) do
    File.write(path, content, [])
  end


  @doc """
  Removes a file from local storage. #{@delegation_warning}

  """
  @spec rm(CloudFile.uri) :: :ok | {:error, CloudFile.reason}
  defdelegate rm(path), to: File


end
