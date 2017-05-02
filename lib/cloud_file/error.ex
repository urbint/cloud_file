defmodule CloudFile.Error do
  @moduledoc false

  defexception [:reason, :path, action: ""]

  defdelegate message(fields), to: File.Error
end
