defmodule CloudFile.Driver.HTTP.Utils do
  @moduledoc """
  Hosts utility functions to support the HTTP Driver's business logic.

  """


  @doc """
  Convenience function to assist in processing successful HTTP requests.

  """
  @spec response_successful?(HTTPoison.Response.t) :: boolean
  def response_successful?(%HTTPoison.Response{status_code: code}) do
    code >= 200 and code < 300
  end


  @doc """
  Converts an HTTPoison response from GCS to a `:file.posix` error code.

  """
  @spec to_posix(HTTPoison.Response.t) :: :file.posix
  def to_posix(res) do
    case res.status_code do
      401 -> :eacces
      404 -> :enoent
      key -> {:unrecognized_error, key}
    end
  end
end
