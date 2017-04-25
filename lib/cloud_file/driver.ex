defmodule CloudFile.Drivers.Driver do
  @moduledoc """
  Behaviour module for creating CloudFile drivers.

  """

  @callback init :: :ok | no_return
  @callback supported_schemes :: [CloudFile.scheme]
  @callback read(CloudFile.uri) :: {:ok, binary} | {:error, CloudFile.reason}
  @callback write(CloudFile.uri, binary) :: :ok | {:error, CloudFile.reason}
  @callback rm(CloudFile.uri) :: :ok | {:error, CloudFile.reason}
end
