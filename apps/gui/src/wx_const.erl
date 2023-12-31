-module(wx_const).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

wx_id_any() ->
  ?wxID_ANY.

wx_sunken_border() ->
  ?wxSUNKEN_BORDER.

wx_gl_rgba() ->
  ?WX_GL_RGBA.

wx_gl_doublebuffer() ->
 ?WX_GL_DOUBLEBUFFER.

wx_gl_min_red() ->
  ?WX_GL_MIN_RED.

wx_gl_min_green() ->
  ?WX_GL_MIN_GREEN.

wx_gl_min_blue() ->
  ?WX_GL_MIN_BLUE.
  
wx_gl_depth_size() ->
  ?WX_GL_DEPTH_SIZE.

wx_listctrl_report() ->
    ?wxLC_REPORT.

wx_vertical() ->
    ?wxVERTICAL.

wx_horizontal() ->
    ?wxHORIZONTAL.

wx_expand() ->
    ?wxEXPAND.

wx_border_simple() ->
    ?wxBORDER_SIMPLE.

wx_stc_margin_number() ->
    ?wxSTC_MARGIN_NUMBER.

wx_stc_margin_symbol() ->
    ?wxSTC_MARGIN_SYMBOL.

wx_default() ->
    ?wxDEFAULT.

wx_te_multiline() ->
    ?wxTE_MULTILINE.
