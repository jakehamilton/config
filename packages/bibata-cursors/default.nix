{ inputs, lib, bibata-cursors, ... }:

bibata-cursors.overrideAttrs (oldAttrs: {
  version = "unstable-2023-03-03";

  src = "${inputs.bibata-cursors}";

  meta = oldAttrs.meta // {
    maintainers = with lib.maintainers;
      oldAttrs.meta.maintainers ++ [ jakehamilton ];
  };
})
