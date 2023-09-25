defmodule ArangoDB.Collection do
  defstruct [:database_id, :spec]

  def name(%__MODULE__{spec: %{"name" => name}}) do
    name
  end
end
