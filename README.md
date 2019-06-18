# Vinkit

Decode VINs (Vehicle Identification Numbers).

## Usage

```
  # in app
  decoder = Vinkit::Decoder.new(vin, adapter: Vinkit::Adapters::Nhtsa)
  decoder.vin
  decoder.year
  decoder.make
  decoder.model

  # command line
  exe/vinkit decode 2B4HB25X9SK575081
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests.
