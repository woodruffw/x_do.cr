require "./spec_helper"

describe XDo::Window do
  pending "#mouse_move" do
  end

  pending "#mouse_down" do
  end

  pending "#mouse_up" do
  end

  pending "#click" do
  end

  pending "#wait_for_map_state" do
  end

  pending "#on_map_state" do
  end

  pending "#wait_for_size_from" do
  end

  pending "#on_size_from" do
  end

  pending "#wait_for_size_to" do
  end

  pending "#on_size_to" do
  end

  pending "#on_size_change" do
  end

  pending "#wait_for_focus" do
  end

  pending "#on_focus" do
  end

  pending "#wait_for_active" do
  end

  pending "#on_active" do
  end

  pending "#type" do
  end

  pending "#keys" do
  end

  pending "#keys_down" do
  end

  pending "#keys_up" do
  end

  pending "#move" do
  end

  pending "#move" do
  end

  describe "#location" do
    it "returns a tuple of the window's location and screen" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          x, y, screen = win.location
          x.should be_a(Int32)
          y.should be_a(Int32)
          screen.should be_a(XDo::Screen)
        end
      end
    end
  end

  describe "#desktop" do
    it "returns the window's desktop number" do
      dummy_window activate: true do |xdo|
        xdo.active_window.desktop.should be_a(Int64)
      end
    end
  end

  pending "#translate_with_hint" do
    it "resizes the window" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          win.translate_with_hint 123, 123
          width, height = win.size

          width.should eq(123)
          height.should eq(123)
        end
      end
    end
  end

  pending "#resize" do
    it "resizes the window" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          win.resize 200, 200
          width, height = win.size

          width.should eq(200)
          height.should eq(200)
        end
      end
    end
  end

  describe "#[]=" do
    it "sets the given property" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          win["WM_NAME"] = "foobar"
          win["WM_NAME"].should eq("foobar")
        end
      end
    end
  end

  describe "#[]" do
    it "retrieves the given property" do
      dummy_window activate: true do |xdo|
        xdo.active_window["WM_NAME"].should eq("xlogo")
      end
    end
  end

  describe "#class_name=" do
    it "sets the window's class name" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          win.class_name = "foobar"
          win["WM_CLASS"].should eq("foobar")
        end
      end
    end
  end

  pending "#class=" do
    it "sets the window's class" do
      dummy_window activate: true do |xdo|
        xdo.active_window do |win|
          win.class = "bazquux"
          puts win["WM_CLASS"]
        end
      end
    end
  end

  pending "#urgent=" do
  end

  pending "#pid" do
    it "gets the window's PID" do
      dummy_window activate: true do |xdo, proc|
        xdo.active_window.pid.should eq(proc.pid)
      end
    end
  end

  describe "#size" do
    it "returns a width and height" do
      dummy_window activate: true do |xdo|
        w, h = xdo.active_window.size
        w.should be_a(UInt32)
        h.should be_a(UInt32)
      end
    end
  end

  pending "#override_redirect=" do
  end

  pending "#activate!" do
  end

  pending "#map!" do
  end

  pending "#unmap!" do
  end

  pending "#minimize!" do
  end

  pending "#focus!" do
  end

  pending "#raise!" do
  end

  pending "#kill!" do
  end

  pending "#close!" do
  end

  pending "#parent" do
  end

  pending "#child" do
  end

  pending "#name" do
  end
end
