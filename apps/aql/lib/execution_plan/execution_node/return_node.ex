defmodule Aql.ExecutionPlan.ExecutionNode.ReturnNode do
  use Aql.ExecutionPlan.ExecutionNode.BaseNode, count: nil, in_variable: nil

  alias Aql.ExecutionPlan.Variable

  @impl true
  def parse_details_from_json(%{"count" => count, "inVariable" => in_variable} = _json) do
    %__MODULE__{count: count, in_variable: Variable.parse_from_json(in_variable)}
  end
end
