require "./x_do/*"

# `XDo` is a Crystal interface for `libxdo`,
# the C library that backs [`xdotool`](https://github.com/jordansissel/xdotool).
#
# It exposes most of the functionality of `xdotool`, allowing
# users to write Crystal programs that manage windows in an X11 instance.
#
# The easiest way to use `XDo` is via `XDo.act`:
#
# ```
# XDo.act do
#   active_window do |win|
#     win.type "hello from Crystal!"
#   end
# end
# ```
class XDo
  private getter xdo_p : LibXDo::XDo*
  getter display : String?

  DEFAULT_DELAY = 12000

  # Returns the version of `libxdo` being used as a `String`.
  def self.lib_version
    String.new(LibXDo.version)
  end

  # Returns a `Hash(String, String)` indicating the current symbol map.
  #
  # ```
  # XDo.symbol_map # => {"alt" => "Alt_L", "ctrl" => "Control_L"}
  # ```
  def self.symbol_map
    map_p = LibXDo.get_symbol_map
    map = Array(String).new
    n = 0

    while map_p[n]
      map << String.new(map_p[n])
      n += 1
    end

    map.in_groups_of(2, "").to_h
  end

  # Yields a block with an `XDo` instance, providing a DSL for interaction.
  #
  # ```
  # XDo.act do
  #   select_window do |win|
  #     win.unmap!
  #     sleep 1
  #     win.map!
  #     win.type "hello"
  #   end
  #
  #   desktop = 3
  # end
  # ```
  def self.act
    xdo = new
    with xdo yield
  end

  # Creates a new `XDo` instance with the given X11 *display*.
  #
  # ```
  # # create an instance on the default display or `DISPLAY` env variable
  # xdo = XDo.new
  #
  # # ...or with a different X display
  # xdo2 = XDo.new(":2")
  #
  # # ... do some work ...
  # ```
  def initialize(display = ENV["DISPLAY"]?)
    @xdo_p = if display
               @display = display
               LibXDo.new(display)
             else
               LibXDo.new(Pointer(UInt8).null)
             end
  end

  # Destroys the instance's internal state.
  def finalize
    LibXDo.free(xdo_p)
  end

  # Moves the mouse to coordinates *x*, *y* on the given *screen*.
  def move_mouse(x, y, screen)
    LibXDo.move_mouse(xdo_p, x, y, screen)
  end

  # Moves the mouse to coordinates *x*, *y* relative to its current position.
  def move_mouse(x, y)
    LibXDo.move_mouse_relative(xdo_p, x, y)
  end

  # Returns the mouse's current position as a tuple of `x` and `y` coordinates,
  # the `screen` it's on, and the `Window` it's over.
  #
  # ```
  # x, y, screen, win = xdo.mouse_location
  # ```
  def mouse_location
    LibXDo.get_mouse_location2(xdo_p, out x, out y, out screen, out window)
    {x, y, screen, Window.new(xdo_p, window)}
  end

  # Wait for the mouse to move from the coordinates *x*, *y*.
  def wait_for_mouse_move_from(x, y)
    LibXDo.wait_for_mouse_move_from(xdo_p, x, y)
  end

  # ditto
  def on_mouse_move_from(x, y, &block)
    wait_for_mouse_move_from(x, y)
    with self yield
  end

  # Wait for the mouse to move to the coordinates *x*, *y*.
  def wait_for_mouse_move_to(x, y)
    LibXDo.wait_for_mouse_move_to(xdo_p, x, y)
  end

  # ditto
  def on_mouse_move_to(x, y, &block)
    wait_for_mouse_move_to(x, y)
    with self yield
  end

  def on_mouse_move(&block)
    x, y, _, _ = mouse_location
    wait_for_mouse_move_from(x, y)
    with self yield
  end

  # Returns a list of `XDo::LibXDo::Charcodemap`s indicating all active modifier keys.
  def active_modifiers
    LibXDo.get_active_modifiers(xdo_p, out keys, out nkeys)
    Array.new(nkeys) { |i| keys[i] }
  end

  # TODO: implement
  def set_active_modifiers
    # NOTE: xdo_set_active_modifiers
    raise "implement me!"
  end

  # TODO: implement
  def clear_active_modifiers
    # NOTE: xdo_clear_active_modifiers
    raise "implement me!"
  end

  # Returns the `Window` that currently has focus.
  #
  # When *sane* is set to `true`, returns the first ancestor-or-self window
  # with the `WM_CLASS` property. When set to `false`, returns the actual focused
  # window (which may not be the application's top-level window).
  def focused_window(*, sane = true)
    window = uninitialized LibXDo::Window

    if sane
      LibXDo.get_focused_window_sane(xdo_p, pointerof(window))
    else
      LibXDo.get_focused_window(xdo_p, pointerof(window))
    end

    Window.new(xdo_p, window)
  end

  # ditto
  def focused_window(*, sane = true, &block)
    yield focused_window(sane: sane)
  end

  # Returns the `Window` that the mouse is currently over.
  def mouse_window
    LibXDo.get_window_at_mouse(xdo_p, out window)
    Window.new(xdo_p, window)
  end

  # ditto
  def mouse_window(&block)
    yield mouse_window
  end

  # Returns the `Window` that is currently active.
  def active_window
    LibXDo.get_active_window(xdo_p, out window)
    Window.new(xdo_p, window)
  end

  # ditto
  def active_window(&block)
    yield active_window
  end

  # Returns the `Window` selected interactively.
  def select_window
    LibXDo.select_window_with_click(xdo_p, out window)
    Window.new(xdo_p, window)
  end

  # ditto
  def select_window(&block)
    yield select_window
  end

  # Takes a `Search` and runs it, returning a list of `Window`s matching the search.
  #
  # ```
  # XDo.act do
  #   query = XDo::Search.build { window_name "Firefox" }
  #   winds = search(query)
  #   puts winds
  # end
  # ```
  def search(query)
    search = query.to_struct
    LibXDo.search_windows(xdo_p, pointerof(search), out windowlist, out nwindows)
    Array.new(nwindows) { |i| Window.new(xdo_p, windowlist[i]) }
  end

  # Like `#search(query)`, but yields a block to build the query directly.
  #
  # ```
  # XDo.act do
  #   winds = search { window_name "Firefox" }
  #   puts winds
  # end
  # ```
  def search(&block)
    query = Search.new
    with query yield
    search(query)
  end

  # Sets the number of desktops.
  def desktops=(ndesktops)
    LibXDo.set_number_of_desktops(xdo_p, ndesktops)
  end

  # Returns the number of desktops.
  def desktops
    LibXDo.get_number_of_desktops(xdo_p, out ndesktops)
    ndesktops
  end

  # Sets the current desktop.
  def desktop=(desktop)
    LibXDo.set_current_desktop(xdo_p, desktop)
  end

  # Returns the current desktop's number.
  def desktop
    LibXDo.get_current_desktop(xdo_p, out desktop)
    desktop
  end

  # Returns the input state, which is the `OR` of any active modifiers
  # in the `KeyMask`.
  def input_state : KeyMask
    LibXDo.get_input_state(xdo_p)
  end

  # Sets the desktop viewport (only relevant if `_NET_DESKTOP_VIEWPORT` is supported).
  #
  # ```
  # XDo.act do
  #   viewport = {x, y}
  # end
  # ```
  def viewport=(tup)
    LibXDo.set_desktop_viewport(xdo_p, *tup)
  end

  # Gets the desktop viewport as an `x`, `y` tuple.
  def viewport
    LibXDo.get_desktop_viewport(xdo_p, out x, out y)
    {x, y}
  end

  # Gets the dimensions of the given screen's viewport as a `width`, `height` tuple.
  def viewport_dimensions(screen)
    LibXDo.get_viewport_dimensions(xdo_p, out width, out height, screen)
    {width, height}
  end

  # Disable an `xdo` feature.
  def disable_feature(feature : XDoFeatures)
    LibXDo.disable_feature(xdo_p, feature)
  end

  # Enable an `xdo` feature.
  def enable_feature(feature : XDoFeatures)
    LibXDo.enable_feature(xdo_p, feature)
  end

  # Test whether a feature is enabled.
  def has_feature?(feature : XDoFeatures)
    LibXDo.has_feature(xdo_p, feature) == 1
  end
end
