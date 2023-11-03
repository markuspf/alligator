defmodule Aql.ExecutionPlan.ExecutionNode.FilterNode do
  use Aql.ExecutionPlan.ExecutionNode.BaseNode

  @impl true
  def parse_details_from_json(_json) do
    %__MODULE__{}
  end
end
