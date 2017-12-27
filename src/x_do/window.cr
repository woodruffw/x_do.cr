class XDo::Window
  private getter xdo_p : LibXDo::XDo*
  private getter window : LibXDo::Window

  def initialize(@xdo_p, @window)
  end

  def move_mouse(x, y)
    LibXDo.move_mouse_relative_to_window(xdo_p, window, x, y)
  end

  def mouse_down(button)
    LibXDo.mouse_down(xdo_p, window, button)
  end

  def mouse_up(button)
    LibXDo.mouse_up(xdo_p, window, button)
  end

  def click(button)
    # TODO: button type enum
    LibXDo.click_button(xdo_p, window, button)
  end

  def click(button, repeat, delay = DEFAULT_DELAY)
    # TODO: button type enum
    LibXDo.click_window_multiple(xdo_p, window, button, repeat, delay)
  end

  def wait_for_map_state(state)
    # TODO: window state enum
    LibXDo.wait_for_window_map_state(xdo_p, win, state)
  end

  def wait_for_map_state(state, &block)
    # TODO: window state enum
    wait_for_map_state(state)
    yield self
  end

  def wait_for_window_size(x, y)
    raise "implement me!"
  end

  def wait_for_window_size(x, y, &block)
    wait_for_window_size(x, y)
    yield self
  end

  def wait_for_focus(*, want_focus = true)
    LibXDo.wait_for_window_focus(xdo_p, window, want_focus.hash)
  end

  def wait_for_focus(*, want_focus = true, &block)
    wait_for_focus(want_focus: want_focus)
    yield self
  end

  def wait_for_active(*, want_active = true)
    LibXDo.wait_for_window_active(xdo_p, window, want_active.hash)
  end

  def wait_for_active(*, want_active = true, &block)
    wait_for_active(want_active: want_active)
    yield self
  end

  def type(text : String, delay = DEFAULT_DELAY)
    LibXDo.enter_text_window(xdo_p, window, text.to_unsafe, delay)
  end

  def keys(keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window(xdo_p, window, keys.to_unsafe, delay)
  end

  def keys(keys : Array(LibXDo::Charcodemap), pressed, modifier, delay = DEFAULT_DELAY)
    raise "implement me!"
  end

  def keys_up(keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window_up(xdo_p, window, keys.to_unsafe, delay)
  end

  def keys_down(keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window_down(xdo_p, window, keys.to_unsafe, delay)
  end

  def move(x, y)
    LibXDo.move_window(xdo_p, window, x, y)
  end

  def move(desktop)
    LibXDo.set_desktop_for_window(xdo_p, window, desktop)
  end

  def location
    LibXDo.get_window_location(xdo_p, window, out x, out y, out screen)
    {x, y, screen}
  end

  def desktop
    LibXDo.get_desktop_for_window(xdo_p, window, out desktop)
    desktop
  end

  def translate_with_hint(x, y)
    LibXDo.translate_window_with_sizehint(xdo_p, window, x, y, out x1, out y1)
    {x1, y1}
  end

  def resize(width, height, flags = 0)
    LibXDo.select_window_size(xdo_p, window, width, height, flags)
  end

  def []=(property : String, value : String)
    LibXDo.set_window_property(xdo_p, window, property.to_unsafe, value.to_unsafe)
  end

  def [](property : Atom)
    raise "implement me!"
  end

  def [](property : String)
    raise "implement me!"
  end

  def class_name=(name : String)
    LibXDo.set_window_class(xdo_p, window, name.to_unsafe, Pointer.null)
  end

  def class=(klass : String)
    LibXDo.set_window_class(xdo_p, window, Pointer.null, klass.to_unsafe)
  end

  def urgency=(urgency)
    # TODO: urgency enum
    LibXDo.set_window_urgency(xdo_p, window, urgency)
  end

  def getpid
    LibXDo.get_pid_window(xdo_p, window)
  end

  def size(window)
    LibXDo.get_window_size(xdo_p, window, out width, out height)
    {width, height}
  end

  def override_redirect=(override_redirect)
    LibXDo.set_window_override_redirect(xdo_p, window, override_redirect)
  end

  def activate!
    LibXDo.activate_window(xdo_p, window)
  end

  def map!
    LibXDo.map_window(xdo_p, window)
  end

  def unmap!
    LibXDo.unmap_window(xdo_p, window)
  end

  def minimize!
    LibXDo.minimize_window(xdo_p, window)
  end

  def focus!
    LibXDo.focus_window(xdo_p, window)
  end

  def raise!
    LibXDo.raise_window(xdo_p, window)
  end

  def kill!
    LibXDo.kill_window(xdo_p, window)
  end

  def close!
    LibXDo.close_window(xdo_p, window)
  end

  def find_client(*, direction = ClientDirection::PARENTS)
    LibXDo.find_window_client(xdo_p, window, out client, direction)
    client
  end

  def name
    # NOTE: xdo_get_window_name
    raise "implement me!"
  end
end
