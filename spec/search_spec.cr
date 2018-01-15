require "./spec_helper"

describe XDo::Search do
  describe ".build" do
    it "builds a new search with the given criteria" do
      search = XDo::Search.build do
        window_class "foo"
        window_class_name "bar"
        window_name "baz"
        pid 1337
        only_visible
        screen 1
        desktop 1
        max_depth 5
        limit 10
      end

      search.should be_a(XDo::Search)

      search.mask.class?.should be_true
      search.mask.class_name?.should be_true
      search.mask.name?.should be_true
      search.mask.pid?.should be_true
      search.mask.only_visible?.should be_true
      search.mask.screen?.should be_true
      search.mask.desktop?.should be_true
    end
  end

  describe "#to_struct" do
    it "fails with an empty search" do
      search = XDo::Search.new

      expect_raises XDo::Error, "can't structify an empty search" do
        search.to_struct
      end
    end

    it "structifies a non-empty search" do
      search = XDo::Search.build { window_name "foo" }

      search.to_struct.should be_a(XDo::LibXDo::Search)
    end
  end
end
