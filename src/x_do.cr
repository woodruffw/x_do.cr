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
#     type win, "hello from Crystal!"
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

  def move_mouse(window, x, y)
    LibXDo.move_mouse_relative_to_window(xdo_p, window, x, y)
  end

  def move_mouse(x, y)
    LibXDo.move_mouse_relative(xdo_p, x, y)
  end

  def mouse_down(window, button)
    LibXDo.mouse_down(xdo_p, window, button)
  end

  def mouse_up(window, button)
    LibXDo.mouse_up(xdo_p, window, button)
  end

  def mouse_location
    LibXDo.get_mouse_location2(xdo_p, out x, out y, out screen, out window)
    {x, y, screen, window}
  end

  def wait_for_mouse_move_from(x, y)
    LibXDo.wait_for_mouse_move_from(xdo_p, x, y)
  end

  def wait_for_mouse_move_to(x, y)
    LibXDo.wait_for_mouse_move_to(xdo_p, x, y)
  end

  def wait_for_window_map_state(window, state)
    LibXDo.wait_for_window_map_state(xdo_p, win, state)
  end

  def wait_for_window_size(window, x, y)
    raise "implement me!"
  end

  def wait_for_window_focus(window, *, want_focus = true)
    LibXDo.wait_for_window_focus(xdo_p, window, want_focus.hash)
  end

  def wait_for_window_active(window, *, want_active = true)
    LibXDo.wait_for_window_active(xdo_p, window, want_active.hash)
  end

  def click(window, button)
    LibXDo.click_window(xdo_p, window, button)
  end

  def click(window, button, repeat, delay = DEFAULT_DELAY)
    LibXDo.click_window_multiple(xdo_p, window, button, repeat, delay)
  end

  def type(window, text : String, delay = DEFAULT_DELAY)
    LibXDo.enter_text_window(xdo_p, window, text.to_unsafe, delay)
  end

  def keys(window, keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window(xdo_p, window, keys.to_unsafe, delay)
  end

  def keys(window, keys : Array(LibXDo::Charcodemap), pressed, modifier, delay = DEFAULT_DELAY)
    raise "implement me!"
  end

  def keys_up(window, keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window_up(xdo_p, window, keys.to_unsafe, delay)
  end

  def keys_down(window, keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window_down(xdo_p, window, keys.to_unsafe, delay)
  end

  def move_window(window, x, y)
    LibXDo.move_window(xdo_p, window, x, y)
  end

  def move_window(window, desktop)
    LibXDo.set_desktop_for_window(xdo_p, window, desktop)
  end

  def window_location(window)
    LibXDo.get_window_location(xdo_p, window, out x, out y, out screen)
    {x, y, screen}
  end

  def window_desktop(window)
    LibXDo.get_desktop_for_window(xdo_p, window, out desktop)
    desktop
  end

  def translate_window_with_hint(window, x, y)
    LibXDo.translate_window_with_sizehint(xdo_p, window, x, y, out x1, out y1)
    {x1, y1}
  end

  def resize_window(window, x, y, flags = 0)
    LibXDo.select_window_size(xdo_p, window, x, y, flags)
  end

  def set_window_property(window, property : String, value : String)
    LibXDo.set_window_property(xdo_p, window, property.to_unsafe, value.to_unsafe)
  end

  def get_window_property(window, property : Atom)
    raise "implement me!"
  end

  def get_window_property(window, property : String)
    raise "implement me!"
  end

  def set_window_class(window, name : String, klass : String)
    LibXDo.set_window_class(xdo_p, window, name.to_unsafe, klass.to_unsafe)
  end

  def set_window_urgency(window, urgency)
    LibXDo.set_window_urgency(xdo_p, window, urgency)
  end

  def getpid(window)
    LibXDo.get_pid_window(xdo_p, window)
  end

  def window_size(window)
    LibXDo.get_window_size(xdo_p, window, out width, out height)
    {width, height}
  end

  def window_override_redirect(window, override_redirect)
    LibXDo.set_window_override_redirect(xdo_p, window, override_redirect)
  end

  def activate_window(window)
    LibXDo.activate_window(xdo_p, window)
  end

  def map_window(window)
    LibXDo.map_window(xdo_p, window)
  end

  def unmap_window(window)
    LibXDo.unmap_window(xdo_p, window)
  end

  def minimize_window(window)
    LibXDo.minimize_window(xdo_p, window)
  end

  def focus_window(window)
    LibXDo.focus_window(xdo_p, window)
  end

  def raise_window(window)
    LibXDo.raise_window(xdo_p, window)
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

    window
  end

  def focused_window(*, sane = false, &block)
    yield focused_window(sane: sane)
  end

  def mouse_window
    LibXDo.get_window_at_mouse(xdo_p, out window)
    window
  end

  def mouse_window(&block)
    yield mouse_window
  end

  def active_window
    LibXDo.get_active_window(xdo_p, out window)
    window
  end

  def active_window(&block)
    yield active_window
  end

  def select_window
    LibXDo.select_window_with_click(xdo_p, out window)
    window
  end

  def search(query)
    raise "implement me!"
  end

  def select_window(&block)
    yield select_window
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

  def kill(window)
    LibXDo.kill_window(xdo_p, window)
  end

  def close(window)
    LibXDo.close_window(xdo_p, window)
  end

  def find_client(window, *, direction = ClientDirection::PARENTS)
    LibXDo.find_window_client(xdo_p, window, out client, direction)
    client
  end

  def name(window)
    # NOTE: xdo_get_window_name
    raise "implement me!"
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
