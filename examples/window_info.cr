# window_info: get information about a selected window

require "../src/x_do"

XDo.act do
  puts "Select a window to query..."
  select_window do |win|
    w, h = win.size
    x, y, screen = win.location
    puts "Window ##{win.window}:"
    puts "\tPID: #{win.pid}"
    puts "\tSize: #{w}x#{h}"
    puts "\tLocation: (#{w}, #{h})"
    puts "\tDesktop: ##{win.desktop}"
    puts "\tOn a #{screen.width}x#{screen.height} screen"
  end
end
