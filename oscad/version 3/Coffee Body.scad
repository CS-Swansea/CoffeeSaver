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

module innerShaft(baseRadius, baseSide, height) {
	lipHeight = 5;
	slotWidth = 20;
	slotDepth = 2;
	slotWall = 2;
	
	difference() {
		union() {	
			roundedRing(baseRadius - 4, baseRadius - 6, baseSide, height);
			roundedRing(baseRadius - 1, baseRadius - 6, baseSide, lipHeight);

			// Horrible messy shit to make the walls for the slots
			translate([-((slotWidth / 2.0) + (slotWall)),((baseRadius - (6 - TOL)) - slotDepth) - slotWall, 0]) cube([slotWidth + (slotWall * 2.0), slotDepth + slotWall, height]);
			rotate([0,0,180]) translate([-((slotWidth / 2.0) + (slotWall)),((baseRadius - (6 - TOL)) - slotDepth) - slotWall, 0]) cube([slotWidth + (slotWall * 2.0), slotDepth + slotWall, height]);
		}

		// Horrible messy Shit to make the slots
		translate([-(slotWidth / 2.0),(baseRadius - (6 - TOL)) - slotDepth,lipHeight+TOL]) cube([slotWidth, slotDepth+10, (height - lipHeight) - slotWall]);
		rotate([0,0,180]) translate([-(slotWidth / 2.0),(baseRadius - (6 - TOL)) - slotDepth,lipHeight+TOL]) cube([slotWidth, slotDepth+10, (height - lipHeight) - slotWall]);
	}
	
}

module complete(perimeter) {
	// Base Radius and Side Length to base all other measures off of
	baseRadius = (perimeter / 10.0);
	baseSide   = calcSideLength(perimeter, baseRadius);

	// Base Thickness for Component Walls
	baseWall = 3.0;
	
	union() {
		translate([0,0,8]) roundedRect(baseRadius + baseWall, baseSide, 3);
		roundedRing(baseRadius + baseWall, baseRadius, baseSide, 10);
		translate([0,0,-15]) innerShaft(baseRadius, baseSide, 25);
	}
}

// Pass in the estimated perimeter 
// of the bag you wish to fit...
complete(260);