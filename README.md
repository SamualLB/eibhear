# Eibhear

Extends Granite models to use translatable fields

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  eibhear:
    github: samuallb/eibhear
```
2. Run `shards install`

## Usage

```crystal
require "eibhear"
```

```crystal
Person < Granite::Base
  include Eibhear::Translatable
end
```
## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/eibhear/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Samual Black](https://github.com/SamualLB) - creator and maintainer
