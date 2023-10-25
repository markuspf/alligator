defmodule Gui.Definitions do
  @behaviour :wx_object

  @title "Definitions Explorer"
  @size {2000, 1000}

  def start_link() do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def create_tree(parent, inst) do
    tree = :wxTreeCtrl.new(parent, [])
    font = :wxFont.new("Fira Code 14")
    :wxTreeCtrl.setFont(tree, font)

    root = :wxTreeCtrl.addRoot(tree, "ArangoDB")

    for %ArangoDB.Database{spec: %{"name" => name, "id" => id}} <- inst.databases do
      db_item = :wxTreeCtrl.appendItem(tree, root, "#{name}")

      IO.puts("item #{db_item} id #{id}")
      IO.puts("#{inspect(inst)}")
      IO.puts("#{inspect(inst.collections)}")
      IO.puts("keys: #{inspect(Map.keys(inst.collections))}")

      f = Map.get(inst.collections, String.to_integer(id))git

      IO.puts("wat: #{inspect(f)}")

      f |> Enum.each(fn {name, _} -> :wxTreeCtrl.appendItem(tree, db_item, name) end)
    end

    tree
  end

  def create_text(parent) do
    text =
      :wxTextCtrl.new(parent, 1,
        style: Bitwise.bor(:wx_const.wx_default(), :wx_const.wx_te_multiline())
      )

    font = :wxFont.new("Fira Code 14")
    :wxTextCtrl.setFont(text, font)

    text
  end

  def init(args \\ []) do
    inst = ArangoDB.Instance.new("/home/makx/scratch/databases/flights/engine-rocksdb")

    wx = :wx.new()
    frame = :wxFrame.new(wx, -1, @title, size: @size)

    panel = :wxPanel.new(frame, [])
    sizer = :wxBoxSizer.new(:wx_const.wx_horizontal())

    tree = create_tree(panel, inst)
    :wxSizer.add(sizer, tree, [{:proportion, 1}, {:flag, :wx_const.wx_expand()}])
    text = create_text(panel)
    :wxSizer.add(sizer, text, [{:proportion, 2}, {:flag, :wx_const.wx_expand()}])

    :wxPanel.setSizer(panel, sizer)
    :wxSizer.fit(sizer, panel)

    :wxFrame.createStatusBar(frame)
    :wxFrame.setStatusText(frame, "BAM")
    :wxFrame.fit(frame)
    :wxFrame.show(frame)

    state = %{tree: tree}
    {frame, state}
  end
end
