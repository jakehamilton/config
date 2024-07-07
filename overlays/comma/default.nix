{ channels, inputs, ... }: final: prev: { inherit (inputs.comma.packages.${final.system}) comma; }
