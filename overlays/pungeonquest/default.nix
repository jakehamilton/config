{ pungeonquest, ... }: final: prev: { inherit (pungeonquest.packages.${prev.system}) pungeonquest; }
