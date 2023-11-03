defmodule Aql.Expression.Value do
  use Aql.Expression, value_type_id: nil, value: nil

  @impl true
  def parse_details_from_json(%{"vTypeID" => value_type_id, "value" => value} = _json) do
    %__MODULE__{value_type_id: value_type_id, value: value}
  end
end
