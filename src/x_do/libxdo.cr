class XDo
  @[Link("xdo")]
  lib LibXDo
    enum Status
      SUCCESS
      ERROR
    end

    type Display = Void*
    type Gc = Void*

    alias KeyCode = UInt8
    alias XID = LibC::ULong
    alias KeySym = XID
    alias XPointer = LibC::Char*
    alias VisualId = LibC::ULong
    alias Colormap = XID
    alias Window = XID
    alias UsecondsT = LibC::UInt
    alias Atom = LibC::ULong

    struct Search
      title : LibC::Char*
      winclass : LibC::Char*
      winclassname : LibC::Char*
      winname : LibC::Char*
      pid : LibC::Int
      max_depth : LibC::Long
      only_visible : LibC::Int
      screen : LibC::Int
      require : LibC::Int
      searchmask : LibC::UInt
      desktop : LibC::Long
      limit : LibC::UInt
    end

    struct XDo
      xdpy : Display
      display_name : LibC::Char*
      charcodes : Charcodemap*
      charcodes_len : LibC::Int
      modmap : XModifierKeymap*
      keymap : KeySym*
      keycode_high : LibC::Int
      keycode_low : LibC::Int
      keysyms_per_keycode : LibC::Int
      close_display_when_freed : LibC::Int
      quiet : LibC::Int
      debug : LibC::Int
      features_mask : LibC::Int
    end

    struct Charcodemap
      key : LibC::Int
      code : KeyCode
      symbol : KeySym
      group : LibC::Int
      modmask : LibC::Int
      needs_binding : LibC::Int
    end

    struct XModifierKeymap
      max_keypermod : LibC::Int
      modifiermap : KeyCode*
    end

    struct Screen
      ext_data : XExtData*
      display : Display
      root : Window
      width : LibC::Int
      height : LibC::Int
      mwidth : LibC::Int
      mheight : LibC::Int
      ndepths : LibC::Int
      depths : Depth*
      root_depth : LibC::Int
      root_visual : Visual*
      default_gc : Gc
      cmap : Colormap
      white_pixel : LibC::ULong
      black_pixel : LibC::ULong
      max_maps : LibC::Int
      min_maps : LibC::Int
      backing_store : LibC::Int
      save_unders : LibC::Int
      root_input_mask : LibC::Long
    end

    struct XExtData
      number : LibC::Int
      next : XExtData*
      free_private : (XExtData* -> LibC::Int)
      private_data : XPointer
    end

    struct Depth
      depth : LibC::Int
      nvisuals : LibC::Int
      visuals : Visual*
    end

    struct Visual
      ext_data : XExtData*
      visualid : VisualId
      class : LibC::Int
      red_mask : LibC::ULong
      green_mask : LibC::ULong
      blue_mask : LibC::ULong
      bits_per_rgb : LibC::Int
      map_entries : LibC::Int
    end

    # NOTE: Unused.
    fun get_mouse_location = xdo_get_mouse_location(xdo : XDo*, x : LibC::Int*, y : LibC::Int*, screen_num : LibC::Int*) : LibC::Int
    fun new_with_opened_display = xdo_new_with_opened_display(xdpy : Display, display : LibC::Char*, close_display_when_freed : LibC::Int) : XDo*

    # TODO: Unimplemented (probably not useful to 99% of users).
    fun send_keysequence_window_list_do = xdo_send_keysequence_window_list_do(xdo : XDo*, window : Window, keys : Charcodemap*, nkeys : LibC::Int, pressed : LibC::Int, modifier : LibC::Int*, delay : UsecondsT) : LibC::Int
    fun get_window_property_by_atom = xdo_get_window_property_by_atom(xdo : XDo*, window : Window, atom : Atom, nitems : LibC::Long*, type : Atom*, size : LibC::Int*) : UInt8*

    fun new = xdo_new(display : LibC::Char*) : XDo*
    fun version = xdo_version : LibC::Char*
    fun free = xdo_free(xdo : XDo*)
    fun move_mouse = xdo_move_mouse(xdo : XDo*, x : LibC::Int, y : LibC::Int, screen : LibC::Int) : LibC::Int
    fun move_mouse_relative_to_window = xdo_move_mouse_relative_to_window(xdo : XDo*, window : Window, x : LibC::Int, y : LibC::Int) : LibC::Int
    fun move_mouse_relative = xdo_move_mouse_relative(xdo : XDo*, x : LibC::Int, y : LibC::Int) : LibC::Int
    fun mouse_down = xdo_mouse_down(xdo : XDo*, window : Window, button : LibC::Int) : LibC::Int
    fun mouse_up = xdo_mouse_up(xdo : XDo*, window : Window, button : LibC::Int) : LibC::Int
    fun get_window_at_mouse = xdo_get_window_at_mouse(xdo : XDo*, window_ret : Window*) : LibC::Int
    fun get_mouse_location2 = xdo_get_mouse_location2(xdo : XDo*, x_ret : LibC::Int*, y_ret : LibC::Int*, screen_num_ret : LibC::Int*, window_ret : Window*) : LibC::Int
    fun wait_for_mouse_move_from = xdo_wait_for_mouse_move_from(xdo : XDo*, origin_x : LibC::Int, origin_y : LibC::Int) : LibC::Int
    fun wait_for_mouse_move_to = xdo_wait_for_mouse_move_to(xdo : XDo*, dest_x : LibC::Int, dest_y : LibC::Int) : LibC::Int
    fun click_window = xdo_click_window(xdo : XDo*, window : Window, button : LibC::Int) : LibC::Int
    fun click_window_multiple = xdo_click_window_multiple(xdo : XDo*, window : Window, button : LibC::Int, repeat : LibC::Int, delay : UsecondsT) : LibC::Int
    fun enter_text_window = xdo_enter_text_window(xdo : XDo*, window : Window, string : LibC::Char*, delay : UsecondsT) : LibC::Int
    fun send_keysequence_window = xdo_send_keysequence_window(xdo : XDo*, window : Window, keysequence : LibC::Char*, delay : UsecondsT) : LibC::Int
    fun send_keysequence_window_up = xdo_send_keysequence_window_up(xdo : XDo*, window : Window, keysequence : LibC::Char*, delay : UsecondsT) : LibC::Int
    fun send_keysequence_window_down = xdo_send_keysequence_window_down(xdo : XDo*, window : Window, keysequence : LibC::Char*, delay : UsecondsT) : LibC::Int
    fun wait_for_window_map_state = xdo_wait_for_window_map_state(xdo : XDo*, wid : Window, map_state : LibC::Int) : LibC::Int
    fun wait_for_window_size = xdo_wait_for_window_size(xdo : XDo*, window : Window, width : LibC::UInt, height : LibC::UInt, flags : LibC::Int, to_or_from : LibC::Int) : LibC::Int
    fun move_window = xdo_move_window(xdo : XDo*, wid : Window, x : LibC::Int, y : LibC::Int) : LibC::Int
    fun translate_window_with_sizehint = xdo_translate_window_with_sizehint(xdo : XDo*, window : Window, width : LibC::UInt, height : LibC::UInt, width_ret : LibC::UInt*, height_ret : LibC::UInt*) : LibC::Int
    fun set_window_size = xdo_set_window_size(xdo : XDo*, wid : Window, w : LibC::Int, h : LibC::Int, flags : LibC::Int) : LibC::Int
    fun set_window_property = xdo_set_window_property(xdo : XDo*, wid : Window, property : LibC::Char*, value : LibC::Char*) : LibC::Int
    fun set_window_class = xdo_set_window_class(xdo : XDo*, wid : Window, name : LibC::Char*, _class : LibC::Char*) : LibC::Int
    fun set_window_urgency = xdo_set_window_urgency(xdo : XDo*, wid : Window, urgency : LibC::Int) : LibC::Int
    fun set_window_override_redirect = xdo_set_window_override_redirect(xdo : XDo*, wid : Window, override_redirect : LibC::Int) : LibC::Int
    fun focus_window = xdo_focus_window(xdo : XDo*, wid : Window) : LibC::Int
    fun raise_window = xdo_raise_window(xdo : XDo*, wid : Window) : LibC::Int
    fun get_focused_window = xdo_get_focused_window(xdo : XDo*, window_ret : Window*) : LibC::Int
    fun wait_for_window_focus = xdo_wait_for_window_focus(xdo : XDo*, window : Window, want_focus : LibC::Int) : LibC::Int
    fun get_pid_window = xdo_get_pid_window(xdo : XDo*, window : Window) : LibC::Int
    fun get_focused_window_sane = xdo_get_focused_window_sane(xdo : XDo*, window_ret : Window*) : LibC::Int
    fun activate_window = xdo_activate_window(xdo : XDo*, wid : Window) : LibC::Int
    fun wait_for_window_active = xdo_wait_for_window_active(xdo : XDo*, window : Window, active : LibC::Int) : LibC::Int
    fun map_window = xdo_map_window(xdo : XDo*, wid : Window) : LibC::Int
    fun unmap_window = xdo_unmap_window(xdo : XDo*, wid : Window) : LibC::Int
    fun minimize_window = xdo_minimize_window(xdo : XDo*, wid : Window) : LibC::Int
    fun reparent_window = xdo_reparent_window(xdo : XDo*, wid_source : Window, wid_target : Window) : LibC::Int
    fun get_window_location = xdo_get_window_location(xdo : XDo*, wid : Window, x_ret : LibC::Int*, y_ret : LibC::Int*, screen_ret : Screen**) : LibC::Int
    fun get_window_size = xdo_get_window_size(xdo : XDo*, wid : Window, width_ret : LibC::UInt*, height_ret : LibC::UInt*) : LibC::Int
    fun get_active_window = xdo_get_active_window(xdo : XDo*, window_ret : Window*) : LibC::Int
    fun select_window_with_click = xdo_select_window_with_click(xdo : XDo*, window_ret : Window*) : LibC::Int
    fun set_number_of_desktops = xdo_set_number_of_desktops(xdo : XDo*, ndesktops : LibC::Long) : LibC::Int
    fun get_number_of_desktops = xdo_get_number_of_desktops(xdo : XDo*, ndesktops : LibC::Long*) : LibC::Int
    fun set_current_desktop = xdo_set_current_desktop(xdo : XDo*, desktop : LibC::Long) : LibC::Int
    fun get_current_desktop = xdo_get_current_desktop(xdo : XDo*, desktop : LibC::Long*) : LibC::Int
    fun set_desktop_for_window = xdo_set_desktop_for_window(xdo : XDo*, wid : Window, desktop : LibC::Long) : LibC::Int
    fun get_desktop_for_window = xdo_get_desktop_for_window(xdo : XDo*, wid : Window, desktop : LibC::Long*) : LibC::Int
    fun search_windows = xdo_search_windows(xdo : XDo*, search : Search*, windowlist_ret : Window**, nwindows_ret : LibC::UInt*) : LibC::Int
    fun get_window_property = xdo_get_window_property(xdo : XDo*, window : Window, property : LibC::Char*, value : UInt8**, nitems : LibC::Long*, type : Atom*, size : LibC::Int*) : LibC::Int
    fun get_input_state = xdo_get_input_state(xdo : XDo*) : ::XDo::KeyMask
    fun get_symbol_map = xdo_get_symbol_map : LibC::Char**
    fun get_active_modifiers = xdo_get_active_modifiers(xdo : XDo*, keys : Charcodemap**, nkeys : LibC::Int*) : LibC::Int
    fun clear_active_modifiers = xdo_clear_active_modifiers(xdo : XDo*, window : Window, active_mods : Charcodemap*, active_mods_n : LibC::Int) : LibC::Int
    fun set_active_modifiers = xdo_set_active_modifiers(xdo : XDo*, window : Window, active_mods : Charcodemap*, active_mods_n : LibC::Int) : LibC::Int
    fun get_desktop_viewport = xdo_get_desktop_viewport(xdo : XDo*, x_ret : LibC::Int*, y_ret : LibC::Int*) : LibC::Int
    fun set_desktop_viewport = xdo_set_desktop_viewport(xdo : XDo*, x : LibC::Int, y : LibC::Int) : LibC::Int
    fun kill_window = xdo_kill_window(xdo : XDo*, window : Window) : LibC::Int
    fun close_window = xdo_close_window(xdo : XDo*, window : Window) : LibC::Int
    fun find_window_client = xdo_find_window_client(xdo : XDo*, window : Window, window_ret : Window*, direction : LibC::Int) : LibC::Int
    fun get_window_name = xdo_get_window_name(xdo : XDo*, window : Window, name_ret : UInt8**, name_len_ret : LibC::Int*, name_type : LibC::Int*) : LibC::Int
    fun disable_feature = xdo_disable_feature(xdo : XDo*, feature : LibC::Int)
    fun enable_feature = xdo_enable_feature(xdo : XDo*, feature : LibC::Int)
    fun has_feature = xdo_has_feature(xdo : XDo*, feature : LibC::Int) : LibC::Int
    fun get_viewport_dimensions = xdo_get_viewport_dimensions(xdo : XDo*, width : LibC::UInt*, height : LibC::UInt*, screen : LibC::Int) : LibC::Int
  end
end
