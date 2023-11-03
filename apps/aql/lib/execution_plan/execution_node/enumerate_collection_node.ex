defmodule Aql.ExecutionPlan.ExecutionNode.EnumerateCollectionNode do
  use Aql.ExecutionPlan.ExecutionNode.BaseNode,
    collection: nil,
    count: nil,
    filter_projections: nil,
    index_hint: nil,
    is_satellite: nil,
    is_satellite_of: nil,
    max_projections: nil,
    out_variable: nil,
    prodduces_result: nil,
    projections: nil,
    random: nil,
    read_own_writes: nil,
    satellite: nil,
    use_cache: nil

  alias Aql.ExecutionPlan.Variable

  @impl true
  def parse_details_from_json(
        %{
          "collection" => collection,
          "count" => count,
          "filterProjections" => filter_projections,
          "indexHint" => index_hint,
          "isSatellite" => is_satellite,
          "isSatelliteOf" => is_satellite_of,
          "maxProjections" => max_projections,
          "outVariable" => out_variable,
          "producesResult" => produces_result,
          "projections" => projections,
          "random" => random,
          "readOwnWrites" => read_own_writes,
          "satellite" => satellite,
          "useCache" => use_cache
        } = _json
      ) do
    %__MODULE__{
      collection: collection,
      count: count,
      filter_projections: filter_projections,
      index_hint: index_hint,
      is_satellite: is_satellite,
      is_satellite_of: is_satellite_of,
      max_projections: max_projections,
      out_variable: Variable.parse_from_json(out_variable),
      prodduces_result: produces_result,
      projections: projections,
      random: random,
      read_own_writes: read_own_writes,
      satellite: satellite,
      use_cache: use_cache
    }
  end
end
