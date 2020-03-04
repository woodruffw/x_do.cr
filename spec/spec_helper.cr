require "spec"
require "../src/x_do"

def dummy_window(*, activate = false, focus = false, &block)
  proc = Process.new("xlogo")

  # xlogo needs a little bit of time
  sleep 0.3

  XDo.act do
    win = search { window_name "xlogo" }.first

    win.activate! if activate
    win.focus! if focus
    yield itself, proc
  end
ensure
  proc.kill if proc && proc.exists?
end
