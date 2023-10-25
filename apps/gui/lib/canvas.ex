defmodule Gui.Canvas do
  @behaviour :wx_object

  @title "Collection: flights"
  @size {1024, 600}

  @margin_line_numbers 0
  @margin_fold 1

  def start_link() do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def hex_dump(bytes) do
    Base.encode16(bytes, case: :lower)
    |> to_charlist
    |> Enum.chunk_every(2)
    |> Enum.join(" ")
  end

  def create_list(parent) do
    box = :wxListBox.new(parent, 1)
    :wxListBox.connect(box, :command_listbox_selected, [:callback])

    font = :wxFont.new("Fira Code 14")
    :wxListBox.setFont(box, font)

    box
  end

  def create_text(parent) do
    text = :wxStyledTextCtrl.new(parent, size: {1200, 600})

    :wxStyledTextCtrl.setMarginWidth(text, @margin_line_numbers, 50)
    :wxStyledTextCtrl.setMarginType(text, @margin_line_numbers, :wx_const.wx_stc_margin_number())

    :wxStyledTextCtrl.setMarginWidth(text, @margin_fold, 15)
    :wxStyledTextCtrl.setMarginType(text, @margin_fold, :wx_const.wx_stc_margin_symbol())

    :wxStyledTextCtrl.setViewWhiteSpace(text, 1)

    :wxStyledTextCtrl.styleSetSize(text, 1, 24)
    text
  end

  def create_box(parent) do
    :wxWindow.new(parent, :wx_const.wx_id_any(),
      style: :wx_const.wx_border_simple(),
      size: {50, 25}
    )
  end

  def init(args \\ []) do
    wx = :wx.new()
    frame = :wxFrame.new(wx, -1, @title, size: @size)

    panel = :wxPanel.new(frame, [])

    sizer = :wxBoxSizer.new(:wx_const.wx_horizontal())

    list = create_list(panel)
    :wxSizer.add(sizer, list, [{:proportion, 1}, {:flag, :wx_const.wx_expand()}])
    text = create_text(panel)
    :wxSizer.add(sizer, text, [{:proportion, 2}, {:flag, :wx_const.wx_expand()}])

    :wxPanel.setSizer(panel, sizer)
    :wxSizer.fit(sizer, panel)

    :wxFrame.createStatusBar(frame)
    :wxFrame.setStatusText(frame, "BAM")
    :wxFrame.fit(frame)
    :wxFrame.show(frame)

    db = StorageEngine.RocksDB.open("/home/makx/scratch/databases/flights/engine-rocksdb")

    docs =
      StorageEngine.RocksDB.get_column_family(db, "Documents")
      |> Enum.map(fn {k, v} -> {k, VelocyPack.decode!(v)} end)
      |> Enum.filter(fn {k, %{3 => coll}} -> coll == 132 end)

    keys = docs |> Enum.map(fn {k, _} -> hex_dump(k) end)

    :wxListBox.insertItems(list, keys, 0)

    #    main_sizer = :wxBoxSizer.new(:wx_const.wx_vertical())
    #    splitter = :wxSplitterWindow.new(frame, [])

    #    sizer = :wxStaticBoxSizer.new(:wx_const.wx_vertical(), frame, [{:label, "hai"}])

    # db = StorageEngine.RocksDB.open("/home/makx/scratch/databases/flights/engine-rocksdb")
    # docs = StorageEngine.RocksDB.get_column_family(db, "Documents") |> Enum.take(1000)

    # keys = docs |> Enum.map(fn {k, _} -> hex_dump(k) end)
    #    docs = []
    #    keys = ["1", "2", "3"]

    #    listbox = :wxListBox.new(splitter, 1, [{:choices, keys}])
    #    textbox = :wxTextCtrl.new(splitter, 1, [{:value, "%{} will appear here"}])

    #    :wxSplitterWindow.splitVertically(splitter, listbox, textbox)
    #    :wxSplitterWindow.setSashGravity(splitter, 0.33)

    #    :wxSizer.add(sizer, splitter, [{:flag, :wx_const.wx_expand()}, {:proportion, 1}])
    #    :wxSizer.add(main_sizer, sizer, [{:flag, :wx_const.wx_expand()}, {:proportion, 1}])

    #    :wxFrame.setSizer(frame, main_sizer)
    #    :wxFrame.show(frame)

    #    :wxSizer.setSizeHints(main_sizer, frame)

    state = %{list: list, text: text, docs: docs}
    {frame, state}
  end

  def handle_event(
        {:wx, _, _, _, {:wxSize, :size, size, _}},
        state = %{listbox: listbox}
      ) do
    #  :wxPanel.setSize(panel, size)
    #  :wxListCtrl.setSize(listbox, size)
    {:noreply, state}
  end

  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  def handle_sync_event(
        {:wx, _, _, _, {:wxCommand, :command_listbox_selected, key, pos, e}},
        _,
        %{docs: docs, text: text} = state
        #        %{text: text, docs: docs} = state
      ) do
    # IO.puts("Selected pos #{pos} with key #{key} staet #{inspect(state)}")

    {key, doc} = Enum.at(docs, pos)

    display =
      Inspect.inspect(doc, %Inspect.Opts{})
      |> Inspect.Algebra.format(50)
      |> IO.iodata_to_binary()

    :wxStyledTextCtrl.setText(text, display)
    :ok
  end
end
