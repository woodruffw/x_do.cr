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

    xdo.free!
  end

  it "initializes with an explicit display" do
    xdo = XDo.new ENV["DISPLAY"]

    xdo.should be_a(XDo)

    xdo.free!
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

  pending "wait_for_mouse_move_from" do
  end

  pending "on_mouse_move_from" do
  end

  pending "wait_for_mouse_move_to" do
  end

  pending "on_mouse_move_to" do
  end

  pending "on_mouse_move" do
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
end
