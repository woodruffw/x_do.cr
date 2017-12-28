# Represents an `XDo` search query.
#
# Queries can contain multiple conditions (such as matching both a window name *and* a
# process ID), as well as impose restrictions on the number of results returned,
# search depth, and extent of search (e.g., limiting the search to a single screen).
#
# See `XDo#search(query)` for an example of using `Search` objects.
class XDo::Search
  getter mask : SearchMask
  @window_class = ""
  @window_class_name = ""
  @window_name = ""
  @pid = 0
  @only_visible = false
  @screen = 0
  @any_or_all = SearchType::Any
  @desktop = 0
  @max_depth = -1 # by default, search everywhere (not just toplevel windows)
  @limit = 0      # by default, do not limit the number of returned results

  # Builds a `Search` instance via a DSL.
  #
  # ```
  # # find no more than 3 windows that are both visible AND have the name "Firefox"
  # Search.build do
  #   require_all
  #   only_visible
  #   window_name "Firefox"
  #   limit 3
  # end
  # ```
  def self.build
    search = new
    with search yield
    search
  end

  # Create a new `Search`.
  #
  # NOTE: New `Search` instances contain no query criteria.
  def initialize
    @mask = SearchMask::None
  end

  # Search for windows whose class are *str*.
  def window_class(str : String)
    @mask |= SearchMask::Class
    @window_class = str
  end

  # Search for windows whose class name are *str*.
  def window_class_name(str : String)
    @mask |= SearchMask::ClassName
    @window_class_name = str
  end

  # Search for windows whose names are *str*.
  def window_name(str : String)
    @mask |= SearchMask::Name
    @window_name = str
  end

  # Search for windows whose (`_NET_WM_PID`) are *pid*.
  def pid(pid)
    @mask |= SearchMask::Pid
    @pid = pid
  end

  # Search only for windows that are currently visible.
  def only_visible
    @mask |= SearchMask::OnlyVisible
    @only_visible = true
  end

  # Search for windows on *screen*.
  def screen(screen)
    @mask |= SearchMask::Screen
    @screen = screen
  end

  # Search for windows on *desktop*.
  def desktop(desktop)
    @mask |= SearchMask::Desktop
    @desktop = desktop
  end

  # Require all criteria to be met, not just one.
  #
  # This is equivalent to requiring the `AND` of all conditions, rather than the
  # `OR` (which is the default).
  def require_all
    @any_or_all = SearchType::All
  end

  # Limit search to a depth of *depth*.
  #
  # `0` guarantees an empty search, `1` limits the search to toplevel windows only.
  # By default, no limit (`-1`) is imposed.
  def max_depth(depth)
    @max_depth = depth
  end

  # Limit the number of results returned. By default, no limit (`0`) is imposed.
  def limit(limit)
    @limit = limit
  end

  # Converts the instance into a struct compatible with `libxdo`.
  # NOTE: You should never have to interact with this method directly.
  def to_struct
    raise Error.new("can't structify an empty search") if @mask.none?

    LibXDo::Search.new(
      winclass: @window_class,
      winclassname: @window_class_name,
      winname: @window_name,
      pid: @pid,
      max_depth: @max_depth,
      only_visible: (@only_visible ? 1 : 0),
      screen: @screen,
      require: @any_or_all,
      searchmask: @mask,
      desktop: @desktop,
      limit: @limit,
    )
  end
end
