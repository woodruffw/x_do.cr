class XDo
  enum Button
    Left        = 1
    Middle
    Right
    ScrollUp
    ScrollDown
    ScrollLeft
    ScrollRight
    Button8
    Button9
  end

  enum ClientDirection
    Parents
    Children
  end

  @[Flags]
  enum KeyMask
    Shift
    Lock
    Control
    Mod1
    Mod2
    Mod3
    Mod4
    Mod5
  end

  enum ResizeFlag
    Pixels    = 0
    UseHints  = 1
    UseHintsX = 2
    UseHintsY = 4
  end

  @[Flags]
  enum SearchMask
    Title # deprecated
    Class
    Name
    Pid
    OnlyVisible
    Screen
    ClassName
    Desktop
  end

  enum SearchType
    Any
    All
  end

  enum WindowMapState
    IsUnmapped
    IsUnviewable
    IsViewable
  end

  enum XDoFeatures
    XTest
  end
end
