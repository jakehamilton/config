{ inputs, ... }:

final: prev: {
	plane = inputs.plane.packages.${prev.system}.plane;
}
