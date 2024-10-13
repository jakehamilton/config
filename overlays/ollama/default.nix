{ channels, ... }:

final: prev: {
	inherit (channels.unstable) ollama;
}
