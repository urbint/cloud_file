defmodule CloudFile.Driver do
  @moduledoc """
  Module for creating CloudFile drivers.

  """

  defmacro __using__(_opts) do
    quote do
      @doc false
      def init, do: {:error, :not_implemented}

      @doc false
      def supported_schemes, do: {:error, :not_implemented}

      @doc false
      def read(_), do: {:error, :not_implemented}

      @doc false
      def write(_, _), do: {:error, :not_implemented}

      @doc false
      def rm(_), do: {:error, :not_implemented}

      @doc false
      def exists?(_), do: {:error, :not_implemented}

      defoverridable [init: 0, supported_schemes: 0, read: 1, write: 2, rm: 1, exists?: 1]
    end

  end
end
