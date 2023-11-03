defmodule Aql.ExecutionPlan.CollectionAccess do
  defstruct name: nil, type: nil

  def parse_type("read"), do: :read
  def parse_type("write"), do: :write
  def parse_type(_), do: nil

  def parse_from_json(%{"name" => name, "type" => type}) do
    %__MODULE__{name: name, type: parse_type(type)}
  end
end
