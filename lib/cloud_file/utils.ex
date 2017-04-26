defmodule CloudFile.Utils do
  @moduledoc false


  @doc """
  Returns a prefix for the storage `driver`.

  Uses the first element of the list returned from the driver's
  `supported_schemes/0` function.

  """
  @spec prefix_for(CloudFile.driver) :: String.t
  def prefix_for(nil), do: ""
  def prefix_for(driver) do
    [scheme | _rest] = driver.supported_schemes()

    "#{scheme}:/"
  end
end
