# Represents an `XDo` view of an X11 screen.
#
# TODO: Expose `depths` and `root_visual`.
#
# ```
# puts "width: #{screen.width}, height: #{screen.height}"
# screen.root_window.move_mouse 0, 0
# ```
class XDo::Screen
  private getter xdo_p : LibXDo::XDo*
  private getter screen_p : LibXDo::Screen*

  private FIELDS = %w[
    width
    height
    mwidth
    mheight
    ndepths
    root_depth
    white_pixel
    black_pixel
    max_maps
    min_maps
    backing_store
    save_unders
    root_input_mask
  ]

  def initialize(@xdo_p, @screen_p)
  end

  {% for field in FIELDS %}
    def {{field.id}}
      screen_p.value.{{field.id}}
    end
  {% end %}

  # Returns a `Window` corresponding to the screen's root.
  def root_window
    Window.new(xdo_p, screen_p.value.root)
  end
end
