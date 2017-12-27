x_do
====

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
    type win, "hello from Crystal!"
  end
end
```

## Contributing

1. Fork it ( https://github.com/woodruffw/x_do/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [woodruffw](https://github.com/woodruffw) William Woodruff - creator, maintainer
