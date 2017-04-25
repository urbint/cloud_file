defmodule CloudFile.Drivers.Local do
  @moduledoc """
  Implements the `CloudFile.Driver` behaviour for local storage.

  """

  @behaviour CloudFile.Driver


  @spec init :: :ok | no_return
  def init, do: :ok


  @doc """
  Returns true if `scheme` refers to a local path.

  """
  @spec supported_schemes :: [CloudFile.scheme]
  def supported_schemes, do: [nil]


  @doc """
  Delegates to Elixir stdlib `File` module.

  """
  @spec read(CloudFile.uri) :: {:ok, binary} | {:error, CloudFile.reason}
  defdelegate read(path), to: File


  @doc """
  Another wrapper around the Elixir stdlib `File` module. Heed the warning
  defined in the `File.write/3` documentation regarding multiple sequential
  fs writes.

  """
  @spec write(CloudFile.uri, binary) :: :ok | {:error, CloudFile.reason}
  def write(path, content) do
    File.write(path, content, [])
  end


  @doc """
  Delegates to Elixir stdlib `File` module.

  """
  @spec rm(CloudFile.uri) :: :ok | {:error, CloudFile.reason}
  defdelegate rm(path), to: File


end
