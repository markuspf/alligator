defmodule Aql.ExecutionPlan.ExecutionNode.LimitNode do
  use Aql.ExecutionPlan.ExecutionNode.BaseNode, full_count: nil, limit: nil, offset: nil

  @impl true
  def parse_details_from_json(
        %{"fullCount" => full_count, "limit" => limit, "offset" => offset} = _json
      ) do
    %__MODULE__{full_count: full_count, limit: limit, offset: offset}
  end
end
