# Bundix

## TODO

* [ ] rewrite this README
* [ ] figure out how best to distribute the `fetch*` functions this uses from our nixpkgs overlay
* [ ] tests I guess
* [ ] platform-specific gem solution
* [ ] more caching improvement

## Platform-specific gems

We kind of deal with this right now but not really adequately because the gemset comes out
platform-specific. We can probably find some way to map nix platforms to gem platforms and fetch the
whole list of versions using the RubyGems API (https://guides.rubygems.org/rubygems-org-api/),
stitch them up, and put platform conditionals in the gemset.
