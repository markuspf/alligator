defmodule Aql.ExecutionPlan.ExecutionNode.UnsupportedNode do
  defstruct content: nil

  def parse_from_json(json) do
    %__MODULE__{content: json}
  end
end
