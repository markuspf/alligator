defmodule Aql.ExecutionPlan.CollectionList do
  defstruct collections: []

  def parse_from_json(list) when is_list(list) do
    %__MODULE__{collections: Enum.map(list, &Collection.parse_from_json/1)}
  end
end
