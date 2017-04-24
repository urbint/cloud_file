defmodule Cloudfile.Driver.Local do
  @moduledoc """
  Implements the `Cloudfile.Driver` behaviour for local storage.

  """

  @behaviour Cloudfile.Driver


  @doc """
  Returns true if `scheme` refers to a local path.

  """
  @spec supported_scheme?(Cloudfile.scheme) :: boolean
  def supported_scheme?(nil), do: true
  def supported_scheme?(_), do: false


  @doc """
  Delegates to Elixir stdlib `File` module.

  """
  @spec read(Cloudfile.uri) :: {:ok, binary} | {:error, Cloudfile.reason}
  defdelegate read(path), to: File


  @doc """
  Another wrapper around the Elixir stdlib `File` module. Heed the warning
  defined in the `File.write/3` documentation regarding multiple sequential
  fs writes.

  """
  @spec write(Cloudfile.uri, binary) :: :ok | {:error, Cloudfile.reason}
  def write(path, content) do
    File.write(path, content, [])
  end


  @doc """
  Delegates to Elixir stdlib `File` module.

  """
  @spec rm(Cloudfile.uri) :: :ok | {:error, Cloudfile.reason}
  defdelegate rm(path), to: File


end
