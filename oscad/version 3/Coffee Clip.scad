TOL = 0.1;

// Calculate how long the side length should be 
// for a rounded rectangle of a given perimeter
// with a known end radius...
function calcSideLength(perimeter, radius) = (perimeter - (6.2831853071 * radius)) / 2.0;

module clipProng(wall, length, thickness) {
	baseKnob = 2;
	baseScale = 1.5;

	baseThumb = 37.5;

	union() {
		cube([wall, length, thickness]);

		translate([0,-baseThumb, 0]) {
			cube([wall, baseThumb, thickness]);
			translate([(wall / 2.0),0,0]) cylinder(h = (thickness), r = (wall / 2.0), center = false, $fn = 100);
		}

		translate([wall,(length - (baseKnob * baseScale)),0]) scale([1,baseScale,1]) cylinder(h = (thickness), r = (baseKnob), center = false, $fn = 100);			 
	}

}

module clip(angle, perimeter, thickness) {
	baseRadius = (perimeter / 10.0) - 3.5;
	baseSide   = (calcSideLength(perimeter, baseRadius) / 2.0) - 12.5;
	baseWall = 8;

	union() {
		difference() {
			cylinder(h = (thickness), r = (baseRadius + baseWall), center = false, $fn = 100);
			translate([0,0,-TOL]) cylinder(h = (thickness + (TOL * 2.0)), r = (baseRadius), center = false, $fn = 100);

			union() {
				rotate([0,0,-angle]) translate([-(baseRadius + baseWall), 0,-TOL]) {
					cube([(baseRadius + baseWall), (baseSide * 10), (thickness + (TOL * 2.0))]);
				}

				rotate([0,0,angle]) translate([0, 0,-TOL]) {
					cube([(baseRadius + baseWall), (baseSide * 10), (thickness + (TOL * 2.0))]);
				}
			}
		}

		union() {
			rotate([0,0,-angle]) translate([-(baseRadius + baseWall), -TOL,0]) {
				clipProng(baseWall, baseSide, thickness);
			}
			rotate([0,0,angle]) translate([(baseRadius + baseWall), -TOL,0]) {
				rotate([0,180,0]) translate([0,0, -thickness]) clipProng(baseWall, baseSide, thickness);
			}
		}
	}
}

// Make a clip with a given degree of tension built in
clip(10, 260, 8); 