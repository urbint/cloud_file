defmodule Cloudfile.Driver.HTTP do
  @moduledoc """
  Implements the `Cloudfile.Driver` behaviour for HTTP storage.

  This module depends on HTTPoison.

  """

  @behaviour Cloudfile.Driver


  @doc """

  """
  @spec read(Cloudfile.uri) :: {:ok, binary} | {:error, Cloudfile.reason}
  def read(url) do
    with {:ok, res} <- HTTPoison.get(url) do
      res.body
    else
      {:error, _reason} = err -> err
    end
  end


  @doc """

  """
  @spec write(Cloudfile.uri, binary) :: :ok | {:error, Cloudfile.reason}
  def write(url, content) do
    with {:ok, _res} <- HTTPoison.post(url, content) do
      :ok
    else
      {:error, _reason} = err -> err
    end
  end


  @doc """

  """
  @spec rm(Cloudfile.uri) :: :ok | {:error, Cloudfile.reason}
  def rm(url) do
    with {:ok, _res} <- HTTPoison.delete(url) do
      :ok
    else
      {:error, _reason} = err -> err
    end
  end


end
