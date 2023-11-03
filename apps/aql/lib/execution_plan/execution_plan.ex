defmodule Aql.ExecutionPlan do
  defstruct collections: [],
            estimatedCost: 0,
            estimatedNrItems: 0,
            isModificationQuery: false,
            nodes: [],
            rules: [],
            variables: []

  alias Aql.ExecutionPlan.CollectionAccess
  alias Aql.ExecutionPlan.ExecutionNode
  alias Aql.ExecutionPlan.Variable

  def eisimplir() do
    Jason.decode!('
{"nodes":[{"type":"SingletonNode","dependencies":[],"id":1,"estimatedCost":1,"estimatedNrItems":1},{"type":"SingletonNode","dependencies":[],"id":2,"estimatedCost":1,"estimatedNrItems":1},{"type":"EnumerateCollectionNode","dependencies":[2],"id":3,"estimatedCost":3,"estimatedNrItems":1,"random":false,"indexHint":{"forced":false,"lookahead":1,"type":"none"},"outVariable":{"id":0,"name":"queue","isFullDocumentFromCollection":false},"projections":[],"filterProjections":[],"count":false,"producesResult":true,"readOwnWrites":false,"useCache":true,"maxProjections":5,"collection":"_queues","satellite":false,"isSatellite":false,"isSatelliteOf":null},{"type":"CalculationNode","dependencies":[3],"id":4,"estimatedCost":4,"estimatedNrItems":1,"expression":{"type":"attribute access","typeID":35,"name":"_key","subNodes":[{"type":"reference","typeID":45,"name":"queue","id":0,"subqueryReference":false}]},"outVariable":{"id":6,"name":"5","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"attribute"},{"type":"ReturnNode","dependencies":[4],"id":5,"estimatedCost":5,"estimatedNrItems":1,"inVariable":{"id":6,"name":"5","isFullDocumentFromCollection":false},"count":false},{"type":"SubqueryNode","dependencies":[1],"id":6,"estimatedCost":6,"estimatedNrItems":1,"subquery":{"nodes":[{"type":"SingletonNode","dependencies":[],"id":2,"estimatedCost":1,"estimatedNrItems":1},{"type":"EnumerateCollectionNode","dependencies":[2],"id":3,"estimatedCost":3,"estimatedNrItems":1,"random":false,"indexHint":{"forced":false,"lookahead":1,"type":"none"},"outVariable":{"id":0,"name":"queue","isFullDocumentFromCollection":false},"projections":[],"filterProjections":[],"count":false,"producesResult":true,"readOwnWrites":false,"useCache":true,"maxProjections":5,"collection":"_queues","satellite":false,"isSatellite":false,"isSatelliteOf":null},{"type":"CalculationNode","dependencies":[3],"id":4,"estimatedCost":4,"estimatedNrItems":1,"expression":{"type":"attribute access","typeID":35,"name":"_key","subNodes":[{"type":"reference","typeID":45,"name":"queue","id":0,"subqueryReference":false}]},"outVariable":{"id":6,"name":"5","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"attribute"},{"type":"ReturnNode","dependencies":[4],"id":5,"estimatedCost":5,"estimatedNrItems":1,"inVariable":{"id":6,"name":"5","isFullDocumentFromCollection":false},"count":false}]},"outVariable":{"id":3,"name":"queues","isFullDocumentFromCollection":false},"isConst":true},{"type":"EnumerateCollectionNode","dependencies":[6],"id":7,"estimatedCost":7,"estimatedNrItems":0,"random":false,"indexHint":{"forced":false,"lookahead":1,"type":"none"},"outVariable":{"id":4,"name":"job","isFullDocumentFromCollection":false},"projections":[],"filterProjections":[],"count":false,"producesResult":true,"readOwnWrites":false,"useCache":true,"maxProjections":5,"collection":"_jobs","satellite":false,"isSatellite":false,"isSatelliteOf":null},{"type":"CalculationNode","dependencies":[7],"id":8,"estimatedCost":7,"estimatedNrItems":0,"expression":{"type":"compare ==","typeID":25,"excludesNull":false,"subNodes":[{"type":"attribute access","typeID":35,"name":"status","subNodes":[{"type":"reference","typeID":45,"name":"job","id":4,"subqueryReference":false}]},{"type":"value","typeID":40,"value":"pending","vTypeID":4}]},"outVariable":{"id":8,"name":"7","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"simple"},{"type":"FilterNode","dependencies":[8],"id":9,"estimatedCost":7,"estimatedNrItems":0,"inVariable":{"id":8,"name":"7","isFullDocumentFromCollection":false}},{"type":"CalculationNode","dependencies":[9],"id":10,"estimatedCost":7,"estimatedNrItems":0,"expression":{"type":"function call","typeID":47,"name":"POSITION","subNodes":[{"type":"array","typeID":41,"subNodes":[{"type":"reference","typeID":45,"name":"queues","id":3,"subqueryReference":false},{"type":"attribute access","typeID":35,"name":"queue","subNodes":[{"type":"reference","typeID":45,"name":"job","id":4,"subqueryReference":false}]},{"type":"value","typeID":40,"value":false,"vTypeID":1}]}]},"outVariable":{"id":10,"name":"9","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"simple"},{"type":"FilterNode","dependencies":[10],"id":11,"estimatedCost":7,"estimatedNrItems":0,"inVariable":{"id":10,"name":"9","isFullDocumentFromCollection":false}},{"type":"CalculationNode","dependencies":[11],"id":12,"estimatedCost":7,"estimatedNrItems":0,"expression":{"type":"compare !=","typeID":26,"subNodes":[{"type":"attribute access","typeID":35,"name":"delayUntil","subNodes":[{"type":"reference","typeID":45,"name":"job","id":4,"subqueryReference":false}]},{"type":"value","typeID":40,"value":null,"vTypeID":0}]},"outVariable":{"id":12,"name":"11","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"simple"},{"type":"FilterNode","dependencies":[12],"id":13,"estimatedCost":7,"estimatedNrItems":0,"inVariable":{"id":12,"name":"11","isFullDocumentFromCollection":false}},{"type":"CalculationNode","dependencies":[13],"id":14,"estimatedCost":7,"estimatedNrItems":0,"expression":{"type":"attribute access","typeID":35,"name":"delayUntil","subNodes":[{"type":"reference","typeID":45,"name":"job","id":4,"subqueryReference":false}]},"outVariable":{"id":14,"name":"13","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"attribute"},{"type":"SortNode","dependencies":[14],"id":15,"estimatedCost":7,"estimatedNrItems":0,"elements":[{"inVariable":{"id":14,"name":"13","isFullDocumentFromCollection":false},"ascending":true}],"stable":false,"limit":0,"strategy":"standard"},{"type":"LimitNode","dependencies":[15],"id":16,"estimatedCost":7,"estimatedNrItems":0,"offset":0,"limit":1,"fullCount":false},{"type":"CalculationNode","dependencies":[16],"id":17,"estimatedCost":7,"estimatedNrItems":0,"expression":{"type":"attribute access","typeID":35,"name":"delayUntil","subNodes":[{"type":"reference","typeID":45,"name":"job","id":4,"subqueryReference":false}]},"outVariable":{"id":16,"name":"15","isFullDocumentFromCollection":false},"canThrow":false,"expressionType":"attribute"},{"type":"ReturnNode","dependencies":[17],"id":18,"estimatedCost":7,"estimatedNrItems":0,"inVariable":{"id":16,"name":"15","isFullDocumentFromCollection":false},"count":true}],"rules":[],"collections":[{"name":"_jobs","type":"read"},{"name":"_queues","type":"read"}],"variables":[{"id":16,"name":"15","isFullDocumentFromCollection":false},{"id":12,"name":"11","isFullDocumentFromCollection":false},{"id":10,"name":"9","isFullDocumentFromCollection":false},{"id":8,"name":"7","isFullDocumentFromCollection":false},{"id":6,"name":"5","isFullDocumentFromCollection":false},{"id":4,"name":"job","isFullDocumentFromCollection":false},{"id":14,"name":"13","isFullDocumentFromCollection":false},{"id":3,"name":"queues","isFullDocumentFromCollection":false},{"id":2,"name":"1","isFullDocumentFromCollection":false},{"id":0,"name":"queue","isFullDocumentFromCollection":false}],"estimatedCost":7,"estimatedNrItems":0,"isModificationQuery":false}
')
  end

  def parse_from_json(plan) do
    %{
      "collections" => collections,
      "estimatedCost" => estimatedCost,
      "estimatedNrItems" => estimatedNrItems,
      "isModificationQuery" => isModificationQuery,
      "nodes" => nodes,
      "rules" => rules,
      "variables" => variables
    } = plan

    %__MODULE__{
      collections: Enum.map(collections, &CollectionAccess.parse_from_json/1),
      estimatedCost: estimatedCost,
      estimatedNrItems: estimatedNrItems,
      isModificationQuery: isModificationQuery,
      nodes: Enum.map(nodes, &ExecutionNode.parse_from_json/1),
      rules: rules,
      variables: Enum.map(variables, &Variable.parse_from_json/1)
    }
  end
end
