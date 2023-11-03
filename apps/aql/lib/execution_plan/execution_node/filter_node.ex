defmodule Aql.ExecutionPlan.ExecutionNode.FilterNode do
  use Aql.ExecutionPlan.ExecutionNode.BaseNode,
    in_variable: nil

  alias Aql.ExecutionPlan.Variable

  @impl true
  def parse_details_from_json(%{"inVariable" => in_variable} = _json) do
    %__MODULE__{in_variable: Variable.parse_from_json(in_variable)}
  end
end
