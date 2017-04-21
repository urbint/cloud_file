defmodule Cloudfile.Driver do
  @moduledoc """
  Behaviour module for creating Cloudfile drivers.

  """

  @callback read(Cloudfile.uri) :: {:ok, binary} | {:error, Cloudfile.reason}
  @callback write(Cloudfile.uri, binary) :: :ok | {:error, Cloudfile.reason}
  @callback rm(Cloudfile.uri) :: :ok | {:error, Cloudfile.reason}
end
