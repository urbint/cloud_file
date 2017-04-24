defmodule Cloudfile.DriverRegistry do
  @moduledoc """
  Registry for Cloudfile drivers. Drivers must register here on initialization.

  """

  def get_driver(nil), do: Cloudfile.Driver.Local
  def get_driver("http"), do: Cloudfile.Driver.HTTP
  def get_driver("https"), do: Cloudfile.Driver.HTTP

  @drivers Application.get_env(:cloudfile, :additional_drivers)

  for driver <- @drivers do
    for scheme <- driver.supported_schemes() do
      def get_driver(unquote(scheme)), do: unquote(driver)
    end
  end

  def get_driver(scheme), do: raise("No driver registered that supports the scheme: \"#{scheme}\"")
end
