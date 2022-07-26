require "./spec_helper"

describe XDo do
  it "returns the libxdo version" do
    XDo.lib_version.should be_a(String)
  end

  it "returns the current symbol map" do
    XDo.symbol_map.should be_a(Hash(String, String))
  end

  it "acts" do
    XDo.act do
      itself.should be_a(XDo)
    end
  end

  it "initializes" do
    xdo = XDo.new

    xdo.should be_a(XDo)
  end

  it "initializes with an explicit display" do
    xdo = XDo.new ENV["DISPLAY"]

    xdo.should be_a(XDo)
  end

  it "moves the mouse on a screen" do
    XDo.act do
      _, _, screen, _ = mouse_location
      move_mouse 50, 50, screen
      x, y, _, _ = mouse_location

      x.should eq(50)
      y.should eq(50)
    end
  end

  it "moves the mouse relative to the current position" do
    XDo.act do
      sx, sy, _, _ = mouse_location
      move_mouse 50, 50
      dx, dy, _, _ = mouse_location

      dx.should eq(sx + 50)
      dy.should eq(sy + 50)
    end
  end

  pending "#wait_for_mouse_move_from" do
  end

  pending "#on_mouse_move_from" do
  end

  pending "#wait_for_mouse_move_to" do
  end

  pending "#on_mouse_move_to" do
  end

  pending "#on_mouse_move" do
  end

  describe "#active_modifiers" do
    it "returns an array of charcodemaps" do
      XDo.act do
        active_modifiers.should be_a(Array(XDo::LibXDo::Charcodemap))
      end
    end
  end

  pending "#set_active_modifiers" do
  end

  pending "#clear_active_modifiers" do
  end

  describe "#focused_window" do
    it "returns a window" do
      XDo.act do
        focused_window.should be_a(XDo::Window)
        focused_window(sane: true).should be_a(XDo::Window)
      end
    end

    it "yields a window in block form" do
      XDo.act do
        focused_window do |win|
          win.should be_a(XDo::Window)
        end

        focused_window sane: true do |win|
          win.should be_a(XDo::Window)
        end
      end
    end
  end

  describe "#mouse_window" do
    it "returns a window" do
      XDo.act do
        mouse_window.should be_a(XDo::Window)
      end
    end

    it "yields a window in block form" do
      XDo.act do
        mouse_window do |win|
          win.should be_a(XDo::Window)
        end
      end
    end
  end

  describe "#active_window" do
    it "returns a window" do
      dummy_window activate: true do |xdo|
        xdo.active_window.should be_a(XDo::Window)
      end
    end

    it "yields a window in block form" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          win.should be_a(XDo::Window)
        end
      end
    end
  end

  pending "#select_window" do
  end

  describe "#search" do
    it "takes a search instance" do
      dummy_window do |xdo|
        query = XDo::Search.build { window_name "xlogo" }

        results = xdo.search(query)

        results.empty?.should be_false
        results.should be_a(Array(XDo::Window))
        results.first.name.should eq("xlogo")
      end
    end

    it "yields with a search DSL" do
      dummy_window do |xdo|
        results = xdo.search { window_name "xlogo" }

        results.empty?.should be_false
        results.should be_a(Array(XDo::Window))
        results.first.name.should eq("xlogo")
      end
    end
  end

  describe "#get_window" do
    it "returns the window" do
      dummy_window activate: true do |xdo|
        active_window = xdo.active_window
        win = xdo.get_window(active_window.window)
        active_window.should eq(win)
      end
    end

    it "returns nil for a bad window id" do
      large_id = 0_u64 &- 1
      XDo.act do
        win = get_window(large_id)
        win.should be_nil
      end
    end

    it "yields the window in block form" do
      dummy_window activate: true do |xdo|
        active_window = xdo.active_window
        xdo.get_window active_window.window do |win|
          active_window.should eq(win)
        end
      end
    end
  end

  pending "sets and retrieves the number of desktops" do
    XDo.act do
      itself.desktops = 3
      desktops.should eq(3)
    end
  end

  pending "sets and retrieves the current desktop" do
    XDo.act do
      itself.desktop = 1
      desktop.should eq(1)
    end
  end

  it "retrieves the current input state mask" do
    XDo.act do
      input_state.should be_a(XDo::KeyMask)
    end
  end

  pending "sets and retrieves the desktop viewport" do
  end

  pending "sets, retrieves, and checks xdo features" do
  end
end
