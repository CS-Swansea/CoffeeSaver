use <../libraries/threads.scad>
use <../libraries/text.scad>

TOL = 0.1;  

// Calculate how long the side length should be 
// for a rounded rectangle of a given perimeter
// with a known end radius...
function calcSideLength(perimeter, radius) = (perimeter - (6.2831853071 * radius)) / 2.0;

// Create a rounded rectangle at origin
module roundedRect(radius, length, thickness, accuracy = 100) {
	hlen = (length / 2.0);
	rad2 = (radius * 2.0);

	union() {
		// Create the two end cylinders at -hlen and hlen from origin
		translate([-hlen, 0, 0]) cylinder(h = (thickness), r = (radius), $fn = (accuracy));
		translate([ hlen, 0, 0]) cylinder(h = (thickness), r = (radius), $fn = (accuracy));
		
		// Create the cuboid which connects the cylinders
		translate([-hlen, -radius, 0]) cube([length, rad2, thickness]);
	}
} 

// Create a rounded ring at origin
module roundedRing(radius, innerRadius, length, thickness, accuracy = 100) {
	difference() {
		roundedRect(radius, length, thickness, accuracy);
		translate([0,0,-TOL]) roundedRect(innerRadius, length, thickness + (TOL * 2.0), accuracy);
	}
}

module cap_socket(rad, thick, pad) {
	union() {
		cylinder(h = pad+1, r = rad, center = false, $fn = 100);
		translate([0,0,pad+1]) metric_thread((rad * 2.0)-1.25, 2, thick, n_starts = 1);
		translate([0,0,(pad + thick+1)]) cylinder(h = 1, r = rad-2, center = false, $fn = 100);
	}
}

module innerShaft(baseRadius, baseSide, height) {
	lipHeight = 5;
	slotWidth = 20;
	slotDepth = 2;
	slotWall = 2;
	slotWall2 = (slotWall * 2.0);
	slotTransX = (slotWidth / 2.0);
	slotTransY = (baseRadius - (6 - TOL)) - slotDepth;
	
	difference() {
		union() {
			// Inner Shaft	
			roundedRing(baseRadius - 4, baseRadius - 6, baseSide, height);
			// Shaft Lip
			roundedRing(baseRadius - 1, baseRadius - 6, baseSide, lipHeight);

			// Walls for the Slots
			translate([-(slotTransX + slotWall),(slotTransY - slotWall), 0]) {
				cube([(slotWidth + (slotWall2)), (slotDepth + slotWall), height]);
			}
			rotate([0,0,180]) translate([-(slotTransX + slotWall),(slotTransY - slotWall), 0]) {
				cube([(slotWidth + (slotWall2)), (slotDepth + slotWall), height]);
			}
		}
		
		// Hollows for Slots
		translate([(-slotTransX),(slotTransY),(lipHeight+TOL)]) {
			cube([slotWidth, (slotDepth+10), ((height - lipHeight) - slotWall)]);
		}
		rotate([0,0,180]) translate([(-slotTransX),(slotTransY),(lipHeight+TOL)]) {
			cube([slotWidth, (slotDepth+10), ((height - lipHeight) - slotWall)]);
		}
	}
	
}

module complete(perimeter) {
	// Base Radius and Side Length to base all other measures off of
	baseRadius = (perimeter / 10.0);
	baseSide   = calcSideLength(perimeter, baseRadius);

	// Base Thickness for Component Walls
	baseWall = 3.0;
	
	difference() {
		union() {
			translate([0,0,8]) roundedRect(baseRadius + baseWall, baseSide, 3);
			roundedRing(baseRadius + baseWall, baseRadius, baseSide, 10);
			translate([0,0,-15]) innerShaft(baseRadius, baseSide, 25);

			translate([(baseSide / 2.0),0,10.02]) cap_socket(14, 5, 1);

			translate([-40,-3,10]) {
				translate([0,3.5,0]) scale([0.85,0.85,2]) drawtext("Coffee");
				translate([15,-3.5,0]) scale([0.85,0.85,2]) drawtext("Saver");

				translate([8,-1,0]) {
					cylinder(h = 1.5, r = 4, center = false, $fn = 100);
				}

				translate([20,3,0]) roundedRing(12, 10, 30, 2);
			}
		}

		translate([(baseSide / 2.0),0,5]) cylinder(h = (20), r = 11, center = false, $fn = 100);
		translate([-40,-3,10]) {
				translate([5.25,-3,0]) scale([0.5,0.5,2]) drawtext("v3");
		}
	}
}

// Pass in the estimated perimeter 
// of the bag you wish to fit...
rotate([180,0,0]) complete(260);