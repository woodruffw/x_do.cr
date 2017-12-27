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

  DEFAULT_DELAY = 12000

  def self.lib_version
    String.new(LibXDo.version)
  end

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

  def self.act
    xdo = new
    with xdo yield
    xdo.free!
  end

  def initialize(display = ":0")
    @xdo_p = LibXDo.new(display.to_unsafe)
  end

  def free!
    LibXDo.free(xdo_p)
  end

  def move_mouse(x, y, screen)
    LibXDo.move_mouse(xdo_p, x, y, screen)
  end

  def move_mouse(x, y)
    LibXDo.move_mouse_relative(xdo_p, x, y)
  end

  def mouse_location
    LibXDo.get_mouse_location2(xdo_p, out x, out y, out screen, out window)
    {x, y, screen, Window.new(xdo_p, window)}
  end

  def wait_for_mouse_move_from(x, y)
    LibXDo.wait_for_mouse_move_from(xdo_p, x, y)
  end

  def wait_for_mouse_move_from(x, y, &block)
    wait_for_mouse_move_from(x, y)
    with self yield
  end

  def wait_for_mouse_move_to(x, y)
    LibXDo.wait_for_mouse_move_to(xdo_p, x, y)
  end

  def wait_for_mouse_move_to(x, y, &block)
    wait_for_mouse_move_to(x, y)
    with self yield
  end

  def active_keys
    # NOTE: xdo_get_active_keys_to_keycode_list
    raise "implement me!"
  end

  def active_modifiers
    # NOTE: xdo_get_active_modifiers
    raise "implement me!"
  end

  def set_active_modifiers
    # NOTE: xdo_set_active_modifiers
    raise "implement me!"
  end

  def clear_active_modifiers
    # NOTE: xdo_clear_active_modifiers
    raise "implement me!"
  end

  def focused_window(*, sane = false)
    if sane
      LibXDo.get_focused_window_sane(xdo_p, out window)
    else
      LibXDo.get_focused_window(xdo_p, out window)
    end

    Window.new(xdo_p, window)
  end

  def focused_window(*, sane = false, &block)
    yield focused_window(sane: sane)
  end

  def mouse_window
    LibXDo.get_window_at_mouse(xdo_p, out window)
    Window.new(xdo_p, window)
  end

  def mouse_window(&block)
    yield mouse_window
  end

  def active_window
    LibXDo.get_active_window(xdo_p, out window)
    Window.new(xdo_p, window)
  end

  def active_window(&block)
    yield active_window
  end

  def select_window
    LibXDo.select_window_with_click(xdo_p, out window)
    Window.new(xdo_p, window)
  end

  def select_window(&block)
    yield select_window
  end

  def search(query)
    raise "implement me!"
  end

  def desktops=(ndesktops)
    LibXDo.set_number_of_desktops(xdo_p, ndesktops)
  end

  def desktops
    LibXDo.get_number_of_desktops(xdo_p, out ndesktops)
    ndesktops
  end

  def current_desktop=(desktop)
    LibXDo.set_current_desktop(xdo_p, desktop)
  end

  def current_desktop
    LibXDo.get_current_desktop(xdo_p, out desktop)
    desktop
  end

  def input_state
    LibXDo.get_input_state(xdo_p)
  end

  def viewport=(x, y)
    LibXDo.set_desktop_viewport(xdo_p, x, y)
  end

  def viewport
    LibXDo.get_desktop_viewport(xdo_p, out x, out y)
    {x, y}
  end

  def viewport_dimensions(screen)
    LibXDo.get_viewport_dimensions(xdo_p, out width, out height, screen)
    {width, height}
  end

  def disable_feature(feature : XDoFeatures)
    LibXDo.disable_feature(xdo_p, feature)
  end

  def enable_feature(feature : XDoFeatures)
    LibXDo.enable_feature(xdo_p, feature)
  end

  def has_feature?(feature : XDoFeatures)
    LibXDo.has_feature(xdo_p, feature) == 1
  end
end
