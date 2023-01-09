{ lib, inputs, snowfall-inputs }:

rec {
  override-meta = meta: package:
    package.overrideAttrs (_: {
      inherit meta;
    });
}
