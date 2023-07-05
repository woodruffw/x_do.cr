x_do
====

![license](https://raster.shields.io/badge/license-MIT%20with%20restrictions-green.png)
[![CI](https://github.com/woodruffw/x_do.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/woodruffw/x_do.cr/actions/workflows/ci.yml)

`XDo` is a Crystal interface for `libxdo`,
the C library that backs [`xdotool`](https://github.com/jordansissel/xdotool).

It exposes most of the functionality of `xdotool`, allowing
users to write Crystal programs that manage windows in an X11 instance.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  x_do:
    github: woodruffw/x_do.cr
```

`libxdo` is required. On Debian-based systems, it can be installed via:

```bash
$ sudo apt install libxdo-dev
```

## Usage

```crystal
require "x_do"

XDo.act do
  active_window do |win|
    win.type "hello from Crystal!"
  end
end
```

Check out the [examples](./examples) folder for some practical examples.

## Testing

The unit tests make the following assumptions:

* You're running an instance of X11
* You're running a window manager that's (mostly) ICCCM and EWMH compliant
* You have `xlogo` installed

To run the unit tests on the default X11 display (`DISPLAY`, falling back on `:0`):

```bash
$ crystal spec
```

Alternatively, the tests can be run on another X11 display, like a Xephyr or Xvfb instance:

```bash
# replace "99" with your display number
$ DISPLAY=:99 crystal spec
```

The `util/xvfb-spec` script can be used to run the tests inside a temporary Xvfb instance running
Openbox:

```bash
$ ./util/xvfb-spec
```

## TODO

* Complete bindings (`grep "implement me!"`)
* Add error conditions (check return value of libxdo calls)

## Contributing

1. Fork it ( https://github.com/woodruffw/x_do/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [woodruffw](https://github.com/woodruffw) William Woodruff - creator, maintainer
