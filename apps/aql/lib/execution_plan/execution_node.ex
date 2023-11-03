defmodule Aql.ExecutionPlan.ExecutionNode do
  alias Aql.ExecutionPlan.ExecutionNode

  def parse_from_json(%{"type" => "SingletonNode"} = node) do
    ExecutionNode.SingletonNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "ReturnNode"} = node) do
    ExecutionNode.ReturnNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "CalculationNode"} = node) do
    ExecutionNode.CalculationNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "EnumerateCollectionNode"} = node) do
    ExecutionNode.EnumerateCollectionNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "FilterNode"} = node) do
    ExecutionNode.FilterNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "LimitNode"} = node) do
    ExecutionNode.LimitNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "SortNode"} = node) do
    ExecutionNode.SortNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => "SubqueryNode"} = node) do
    ExecutionNode.SubqueryNode.parse_from_json(node)
  end

  def parse_from_json(%{"type" => type} = node) do
    IO.puts("Unsupported ExecutionNode type `#{type}`")
    ExecutionNode.UnsupportedNode.parse_from_json(node)
  end
end
