defmodule Gui.Definitions do
  @behaviour :wx_object

  @title "Definitions Explorer"
  @size {2000, 1000}

  def start_link() do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def create_tree(parent) do
    tree = :wxTreeCtrl.new(parent, [])
    font = :wxFont.new("Fira Code 14")
    :wxTreeCtrl.setFont(tree, font)
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
    wx = :wx.new()
    frame = :wxFrame.new(wx, -1, @title, size: @size)

    panel = :wxPanel.new(frame, [])
    sizer = :wxBoxSizer.new(:wx_const.wx_horizontal())

    tree = create_tree(panel)
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
