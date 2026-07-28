{ config }:
let
  inherit (config) lib;
in
{
  config.lib.colors = rec {
    without-hash = color: builtins.substring 1 (builtins.stringLength color) color;

    nord = {
      nord0 = "#2E3440";
      nord1 = "#3B4252";
      nord2 = "#434C5E";
      nord3 = "#4C566A";
      nord4 = "#D8DEE9";
      nord5 = "#E5E9F0";
      nord6 = "#ECEFF4";
      nord7 = "#8FBCBB";
      nord8 = "#88C0D0";
      nord9 = "#81A1C1";
      nord10 = "#5E81AC";
      nord11 = "#BF616A";
      nord12 = "#D08770";
      nord13 = "#EBCB8B";
      nord14 = "#A3BE8C";
      nord15 = "#B48EAD";
    };

    bliss = {
      surface = "#1E1A24";
      surface-light = "#23202B";
      surface-lighter = "#282636";
      surface-lightest = "#2E2B3D";
      surface-dark = "#181520";
      surface-darker = "#14111B";

      text = "#EEEAF1";
      text-dark = "#827889";

      sakura = "#E598B8";
      sakura-light = "#F6B7D1";
      sakura-dark = "#C47793";

      mint = "#91D5C7";
      mint-light = "#B4EFE3";
      mint-dark = "#77B0A4";

      peach = "#E8B0A0";
      peach-light = "#F4C8BD";
      peach-dark = "#C79285";

      sky = "#A8C9E7";
      sky-light = "#D1E4F3";
      sky-dark = "#88B0D8";

      berry = "#CE98BD";
      berry-light = "#E8BADA";
      berry-dark = "#A67396";
    };

    palette = {
      black = bliss.surface;
      black-bright = bliss.surface-light;
      black-dim = bliss.surface-dark;

      red = bliss.sakura;
      red-bright = bliss.sakura-light;
      red-dim = bliss.sakura-dark;

      green = bliss.mint;
      green-bright = bliss.mint-light;
      green-dim = bliss.mint-dark;

      yellow = bliss.peach;
      yellow-bright = bliss.peach-light;
      yellow-dim = bliss.peach-dark;

      blue = bliss.sky;
      blue-bright = bliss.sky-light;
      blue-dim = bliss.sky-dark;

      magenta = bliss.berry;
      magenta-bright = bliss.berry-light;
      magenta-dim = bliss.berry-dark;

      cyan = bliss.sky;
      cyan-bright = bliss.sky-light;
      cyan-dim = bliss.sky-dark;

      white = bliss.text;
      white-dim = bliss.text-dark;
    };

    syntax = {
      comment = bliss.text-dark;
      "comment.block" = bliss.text-dark;
      "comment.documentation" = bliss.sakura;
      "comment.line" = bliss.text-dark;

      constant = bliss.sakura;
      "constant.character" = bliss.sakura;
      "constant.character.entity" = bliss.sakura;
      "constant.character.escape" = bliss.sakura;
      "constant.language" = bliss.sky;
      "constant.numeric" = bliss.peach;
      "constant.numeric.float" = bliss.peach;
      "constant.numeric.hex" = bliss.peach;
      "constant.numeric.integer" = bliss.peach;
      "constant.other" = bliss.text;

      entity = bliss.text;
      "entity.name" = bliss.text;
      "entity.name.class" = bliss.sakura;
      "entity.name.function" = bliss.sakura;
      "entity.name.function.constructor" = bliss.sakura;
      "entity.name.label" = bliss.mint;
      "entity.name.namespace" = bliss.berry;
      "entity.name.section" = bliss.sakura;
      "entity.name.tag" = bliss.sakura;
      "entity.name.type" = bliss.mint;
      "entity.name.type.class" = bliss.mint;
      "entity.name.type.enum" = bliss.mint;
      "entity.other" = bliss.text;

      invalid = bliss.sakura-light;
      "invalid.deprecated" = bliss.text-dark;
      "invalid.illegal" = bliss.sakura-light;

      keyword = bliss.sakura;
      "keyword.operator" = bliss.sakura;

      markup = bliss.text-dark;
      "markup.changed" = bliss.peach;
      "markup.deleted" = bliss.sakura;
      "markup.inserted" = bliss.mint;
      "markup.list" = bliss.text;
      "markup.quote" = bliss.text;
      "markup.raw" = bliss.text;

      meta = bliss.text;

      punctuation = bliss.text;

      storage = bliss.mint;
      "storage.modifier" = bliss.sakura;
      "storage.type" = bliss.mint;

      string = bliss.mint;
      "string.interpolated" = bliss.sakura;
      "string.other" = bliss.sky;
      "string.quoted.double" = bliss.mint;
      "string.quoted.single" = bliss.mint;
      "string.regexp" = bliss.mint;
      "string.template" = bliss.mint;
      "string.unquoted" = bliss.text;

      support = bliss.sakura;
      "support.type" = bliss.mint;
      "support.variable" = bliss.sakura;
      "support.other" = bliss.peach;

      variable = bliss.text;
      "variable.language" = bliss.sakura;
      "variable.parameter" = bliss.sakura;
      "variable.other" = bliss.text;
      "variable.other.constant" = bliss.sakura;
      "variable.other.object" = bliss.peach;
    };

    ui = {
      "accent.normal" = bliss.sakura;

      "border.normal" = bliss.surface-dark;

      "chrome.background.normal" = bliss.surface;
      "chrome.background.light" = bliss.surface-light;
      "chrome.background.dark" = bliss.surface-dark;

      "chrome.foreground.light" = bliss.surface-lightest;
      "chrome.foreground.dark" = bliss.surface-light;

      "cursor.muted.foreground" = bliss.text-dark;
      "cursor.muted.background" = bliss.surface-darker;

      "cursor.normal.foreground" = bliss.text;
      "cursor.normal.background" = bliss.surface;

      deprecated = bliss.text-dark;

      "global.background.dark" = bliss.surface-darker;
      "global.background.light" = bliss.surface;

      "global.foreground.dark" = bliss.text;
      "global.foreground.light" = bliss.sakura;

      "gutter.background" = bliss.surface;
      "gutter.foreground" = bliss.text;

      "link.normal.foreground" = bliss.sakura;
      "link.normal.background" = bliss.surface;

      "selection.foreground" = bliss.surface-dark;
      "selection.background" = bliss.mint;
      "selection.inactive-background" = bliss.mint-light;

      "status.error" = bliss.sakura;
      "status.info" = bliss.berry;
      "status.success" = bliss.mint;
      "status.warning" = bliss.peach;

      "tooltip.foreground" = bliss.text;
      "tooltip.background" = bliss.surface-light;

      "whitespace.foreground" = bliss.text-dark;
    };

    base16 = {
      scheme = "Bliss";
      author = "Jake Hamilton <jake.hamilton@hey.com>";
      slug = "bliss";

      # Background.
      base00 = without-hash bliss.surface;
      base01 = without-hash bliss.surface-light;
      base02 = without-hash bliss.surface-lighter;

      # Text
      base03 = without-hash bliss.text-dark;
      base04 = without-hash bliss.text-dark;
      base05 = without-hash bliss.text;
      base06 = without-hash bliss.text;
      base07 = without-hash bliss.text;

      # Accent colors.
      base08 = without-hash bliss.sakura;
      base09 = without-hash bliss.peach;
      base0A = without-hash bliss.peach-light;
      base0B = without-hash bliss.mint;
      base0C = without-hash bliss.mint-light;
      base0D = without-hash bliss.sky;
      base0E = without-hash bliss.berry;
      base0F = without-hash bliss.sakura-dark;
    };
  };
}
