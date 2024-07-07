{ noop-ai-website, ... }:

final: prev: { noop-ai-website = noop-ai-website.packages.${prev.system}.website; }
