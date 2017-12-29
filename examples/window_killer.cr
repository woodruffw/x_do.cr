# window_killer: kills a user-selected window

require "../src/x_do"

XDo.act do
  puts "Select a window to kill..."
  select_window do |win|
    win.kill!
  end
end
