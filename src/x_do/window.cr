# Represents an `XDo` view of an X11 window.
#
# ```
# win.move_mouse 0, 0
# puts "typing inside #{win["WM_NAME"]}"
# win.type "hello!"
# ```
class XDo::Window
  private getter xdo_p : LibXDo::XDo*
  getter window : LibXDo::Window

  def initialize(@xdo_p, @window)
  end

  # Returns true if `other` has the same X11 window ID (WID).
  def ==(other)
    return false unless other.is_a?(Window)

    other.window == window
  end

  # Move the mouse relative to this window.
  def move_mouse(x, y)
    LibXDo.move_mouse_relative_to_window(xdo_p, window, x, y)
  end

  # Send a mouse-down event for the given mouse *button* to this window.
  def mouse_down(button : Button)
    LibXDo.mouse_down(xdo_p, window, button)
  end

  # Send a mouse-up event for the given mouse *button* to this window.
  def mouse_up(button : Button)
    LibXDo.mouse_up(xdo_p, window, button)
  end

  # Click the given mouse *button* on this window (mouse-down + mouse-up)
  def click(button : Button)
    LibXDo.click_window(xdo_p, window, button)
  end

  # Click the given mouse *button* *repeat* times, with *delay* between each click.
  def click(button : Button, repeat, delay = DEFAULT_DELAY)
    LibXDo.click_window_multiple(xdo_p, window, button, repeat, delay)
  end

  # Wait for the window's map state to become *state*.
  def wait_for_map_state(state : WindowMapState)
    LibXDo.wait_for_window_map_state(xdo_p, win, state)
  end

  # :ditto:
  def on_map_state(state : WindowMapState, &block)
    wait_for_map_state(state)
    yield self
  end

  # Wait for the window's dimensions to change **from** *width* x *height* to something else.
  #
  # If *use_hints* is set to true, the supplied dimensions are measured
  # according to the window's size hints (not necessarily pixels).
  def wait_for_size_from(width, height, use_hints = false)
    LibXDo.wait_for_window_size(xdo_p, window, width, height, use_hints ? 1 : 0, 1)
  end

  # :ditto:
  def on_size_from(width, height, use_hints = false, &block)
    wait_for_size_from(width, height)
    yield self
  end

  # Wait for the window's dimensions to change **to** *width* x *height* from something else.
  #
  # If *use_hints* is set to true, the supplied dimensions are measured
  # according to the window's size hints (not necessarily pixels).
  def wait_for_size_to(width, height, use_hints = false)
    LibXDo.wait_for_window_size(xdo_p, window, width, height, use_hints ? 1 : 0, 0)
  end

  # :ditto:
  def on_size_to(width, height, use_hints = false)
    wait_for_size_to(width, height)
    yield self
  end

  # Wait for the window's dimensions to change, and yield `self`.
  #
  # ```
  # window.on_size_change do
  #   puts "my new size is: #{window.size}"
  # end
  # ```
  def on_size_change(&block)
    wait_for_size_from(*size)
    yield self
  end

  # Wait for the window to gain or lose focus, per *want_focus*.
  def wait_for_focus(*, want_focus = true)
    LibXDo.wait_for_window_focus(xdo_p, window, want_focus ? 1 : 0)
  end

  # :ditto:
  def on_focus(*, want_focus = true, &block)
    wait_for_focus(want_focus: want_focus)
    yield self
  end

  # Wait for the window to become active or inactive, per *want_active*.
  def wait_for_active(*, want_active = true)
    LibXDo.wait_for_window_active(xdo_p, window, want_active ? 1 : 0)
  end

  # :ditto:
  def on_active(*, want_active = true, &block)
    wait_for_active(want_active: want_active)
    yield self
  end

  # Send some *text* to the window, with *delay* between the keystrokes.
  #
  # ```
  # win.type "hello from Crystal!"
  # ```
  def type(text : String, delay = DEFAULT_DELAY)
    LibXDo.enter_text_window(xdo_p, window, text, delay)
  end

  # Send some *keys* (down + up) to the window, with *delay* between them.
  #
  # ```
  # win.keys "Ctrl+s"
  # ```
  def keys(keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window(xdo_p, window, keys, delay)
  end

  # Send some key press (down) events for the given *keys*, with *delay* between them.
  # See `#keys_up`.
  #
  # ```
  # win.keys_down "Ctrl+o"
  # ```
  def keys_down(keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window_down(xdo_p, window, keys, delay)
  end

  # Send some key release (up) events for the given *keys*, with *delay* between them.
  # See `#keys_down`.
  #
  # ```
  # win.keys_up "Ctrl+o"
  # ```
  def keys_up(keys : String, delay = DEFAULT_DELAY)
    LibXDo.send_keysequence_window_up(xdo_p, window, keys, delay)
  end

  # Attempt to move the window to *x*, *y* on the screen.
  #
  # ```
  # # try to put the window in the upper left corner
  # win.move 0, 0
  # ```
  def move(x, y)
    LibXDo.move_window(xdo_p, window, x, y)
  end

  # Attempt to move the window to *desktop*.
  #
  # ```
  # # try to move the window to desktop #3
  # win.move 3
  # ```
  def move(desktop)
    LibXDo.set_desktop_for_window(xdo_p, window, desktop)
  end

  # Get the window's location, consisting of a tuple of `width`, `height`,
  # and `Screen` object
  #
  # ```
  # x, y, screen = win.location
  # ```
  def location
    LibXDo.get_window_location(xdo_p, window, out x, out y, out screen)
    {x, y, Screen.new(xdo_p, screen)}
  end

  # Get the window's desktop number.
  #
  # ```
  # desktop = win.desktop
  # ```
  def desktop
    LibXDo.get_desktop_for_window(xdo_p, window, out desktop)
    desktop
  end

  # Attempt to apply the window's sizing hints with the given *width* and *height*.
  #
  # Uses `XGetWMNormalHints()` internally to determine the resize increment and base size.
  #
  # ```
  # win.translate_with_hint 100, 100
  # ```
  def translate_with_hint(width, height)
    LibXDo.translate_window_with_sizehint(xdo_p, window, width, height, out width1, out height1)
    {width1, height1}
  end

  # Attempt to change the window's size to *width* x *height*, scaled by *flags*.
  #
  # ```
  # # make the window 100px by 100px
  # win.resize 100, 100
  #
  # # make the window 500 by 500 size-hint units
  # win.resize 500, 500, ResizeFlag::UseHints
  # ```
  def resize(width, height, flags : ResizeFlag = ResizeFlag::Pixels)
    LibXDo.set_window_size(xdo_p, window, width, height, flags)
  end

  # Set the window's *property* property to *value*.
  #
  # ```
  # # change the window's title-bar name
  # win["WM_NAME"] = "my custom window name"
  # ```
  def []=(property : String, value : String)
    LibXDo.set_window_property(xdo_p, window, property, value)
  end

  # Get the value associated with the *property* property.
  #
  # NOTE: Always returns a string, regardless of the underlying X11 atom. As a result,
  # this method can return "garbage" strings for some property names.
  def [](property : String)
    LibXDo.get_window_property(xdo_p, window, property, out value, out _, out _, out _)
    String.new(value)
  end

  # Set the window's class name (`WM_CLASS` instance name) to *name*.
  #
  # ```
  # win.class_name = "my-custom-instance"
  # ```
  def class_name=(name : String)
    LibXDo.set_window_class(xdo_p, window, name, Pointer(UInt8).null)
  end

  # Set the window's class (`WM_CLASS` class name) to *klass*.
  #
  # ```
  # win.class = "my-custom-class"
  # ```
  def class=(klass : String)
    LibXDo.set_window_class(xdo_p, window, Pointer(UInt8).null, klass)
  end

  # Set the window's urgency hint.
  #
  # ```
  # # tell the WM to indicate the window's urgency to the user
  # win.urgent = true
  # ```
  def urgent=(urgent : Bool)
    LibXDo.set_window_urgency(xdo_p, window, urgent ? 1 : 0)
  end

  # Return the process ID associated with the window, or `0` if not found.
  def pid
    LibXDo.get_pid_window(xdo_p, window)
  end

  # Return the size of the window as a tuple of `width` and `height`.
  #
  # ```
  # width, height = win.size
  # ```
  def size
    LibXDo.get_window_size(xdo_p, window, out width, out height)
    {width, height}
  end

  # Set the window's override-redirect flag.
  #
  # ```
  # win.override_redirect = true
  # ```
  def override_redirect=(override_redirect : Bool)
    LibXDo.set_window_override_redirect(xdo_p, window, override_redirect ? 1 : 0)
  end

  # Activates the window. Requires `_NET_ACTIVE_WINDOW` from EWMH.
  #
  # See `#focus!` for WMs without `_NET_ACTIVE_WINDOW`.
  #
  # ```
  # # switch to the window's desktop and raise it
  # win.activate!
  # ```
  def activate!
    LibXDo.activate_window(xdo_p, window)
  end

  # Maps the window, making it visible if previously unmapped. See `#unmap!`.
  def map!
    LibXDo.map_window(xdo_p, window)
  end

  # Unmaps the window, making it invisible. See `#map!`.
  def unmap!
    LibXDo.unmap_window(xdo_p, window)
  end

  # Minimizes the window.
  def minimize!
    LibXDo.minimize_window(xdo_p, window)
  end

  # Focuses the window.
  #
  # See `#activate!` for WMs with `_NET_ACTIVE_WINDOW`.
  def focus!
    LibXDo.focus_window(xdo_p, window)
  end

  # Raises the window (bringing it to the foreground).
  def raise!
    LibXDo.raise_window(xdo_p, window)
  end

  # Kills a window and the client owning it.
  #
  # To close a window without killing its client, see `#close!`.
  def kill!
    LibXDo.kill_window(xdo_p, window)
  end

  # Closes a window without trying to kill its client.
  #
  # To kill the client while closing a window, see `#kill!`.
  def close!
    LibXDo.close_window(xdo_p, window)
  end

  # Attempt to find the window's parent.
  def parent
    status = LibXDo.find_window_client(xdo_p, window, out client, ClientDirection::Parents)

    raise XDo::Error.new("unable to find parent window") unless status.success?

    Window.new(xdo_p, client)
  end

  # Attempt to find the window's child.
  def child
    status = LibXDo.find_window_client(xdo_p, window, out client, ClientDirection::Children)

    raise XDo::Error.new("unable to find child window") unless status.success?

    Window.new(xdo_p, client)
  end

  # Get the window's name (`WM_NAME`), if any.
  def name
    LibXDo.get_window_name(xdo_p, window, out name, out _, out _)
    String.new(name) unless name.null?
  end
end
