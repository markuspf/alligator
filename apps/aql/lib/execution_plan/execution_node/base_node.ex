defmodule Aql.ExecutionPlan.ExecutionNode.BaseNode do
  defstruct id: nil, estimated_cost: nil, estimated_nr_items: nil

  @callback parse_details_from_json(json :: any()) :: any()

  defmacro __using__(fields) do
    quote do
      @behaviour Aql.ExecutionPlan.ExecutionNode.BaseNode

      defstruct [
                  :id,
                  :estimated_cost,
                  :estimated_nr_items
                ] ++ unquote(fields)

      @type t :: %__MODULE__{
              id: integer(),
              estimated_cost: number(),
              estimated_nr_items: integer
            }

      def parse_from_json(
            %{
              "id" => id,
              "estimatedCost" => estimated_cost,
              "estimatedNrItems" => estimated_nr_items
            } = node
          ) do
        %__MODULE__{
          parse_details_from_json(node)
          | id: id,
            estimated_cost: estimated_cost,
            estimated_nr_items: estimated_nr_items
        }
      end
    end
  end
end
