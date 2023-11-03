defmodule Aql.ExecutionPlan.ExecutionNode.CalculationNode do
  use Aql.ExecutionPlan.ExecutionNode.BaseNode, expression: nil

  @impl true
  def parse_details_from_json(%{"expression" => expression} = _json) do
    %__MODULE__{expression: expression}
  end
end
