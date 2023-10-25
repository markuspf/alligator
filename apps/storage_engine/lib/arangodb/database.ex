defmodule ArangoDB.Database do
  defstruct spec: %{},
            collections: %{}

  def name(%__MODULE__{spec: %{"name" => name}}), do: name
end
