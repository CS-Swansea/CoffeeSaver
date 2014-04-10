use <threads.scad>
use <pyramid.scad>
use <text.scad>

module base(perimeter, rad, thickness) {
	
	vP = (perimeter - (rad * 6.2831853071)) / 2.0;
	union() {
		translate([-(vP/2.0), 0,0]) cylinder(h = thickness, r = rad, center = false, $fn = 100);
		translate([(vP/2.0), 0,0]) cylinder(h = thickness, r = rad, center = false, $fn = 100);
		translate([0,0, (thickness / 2.0)]) cube([vP,(rad * 2.0),thickness],center = true);
	}

}

module ring(p1,p2, rad, rad2, thickness) {
	
	vP = (p1 - (rad * 6.2831853071)) / 2.0;
	vP2 = (p2 - (rad2 * 6.2831853071)) / 2.0;
	
	intersection() {
	difference() {
		union() {
			translate([-(vP/2.0), 0,0]) cylinder(h = thickness, r1 = rad,r2 = rad2, center = false, $fn = 100);
			translate([(vP/2.0), 0,0]) cylinder(h = thickness, r1 = rad,r2 = rad2, center = false, $fn = 100);
			intersection() {
				translate([0,0, (thickness / 2.0)]) cube([vP,(rad * 2.0),thickness],center = true);
				translate([-((vP+2)/2.0), -(rad),0]) pyramid(vP+2,(rad * 2.0),67.5);
			}
		}

		translate([0,0,-1]) base(220, 18, (thickness+2));
		
	}
		translate([0,0,-1]) base(252.5,24.5,(thickness+2));
	}

}

module cap_socket(rad, thick, pad) {
	union() {
		cylinder(h = pad+1, r = rad, center = false, $fn = 100);
		translate([0,0,pad+1]) metric_thread((rad * 2.0)-1, 2, thick, n_starts = 1);
		translate([0,0,(pad + thick+1)]) cylinder(h = 1, r = rad-2, center = false, $fn = 100);
	}
}

module top_cap(rad, thick, pad) {
	intersection() {
		difference() {
			cylinder(h = (pad + thick+2), r = rad+2, center = false, $fn = 12);

			union() {
				translate([0,0,-2]) cylinder(h = pad+2.01, r = rad, center = false, $fn = 100);
				translate([0,0,pad]) metric_thread((rad * 2.0), 2, thick, n_starts = 1, internal = true);
				translate([0,0,(pad + thick-0.01)]) cylinder(h = 1.05, r = rad-1, center = false, $fn = 100);
			}
		}
		translate([0,0,-1]) cylinder(h = (pad + thick+4), r = rad+1.75, center = false, $fn = 1000);
	}
}

module base_cap() {
	difference() {
		union() { 
			
			translate([-35,-3,9]) {
				translate([0,3.5,0]) scale([0.85,0.85,2]) drawtext("Coffee");
				translate([15,-3.5,0]) scale([0.85,0.85,2]) drawtext("Saver");
			} 

			difference() {
				union() {
					translate([0,0,8]) base(270, 25, 2);

					translate([0,0,-10]) difference() {
						base(270, 25, 19);
						translate([0,0,-1]) base(260, 23, 100);
					}

					translate([0,0,7.77]) {
						intersection() {
							rotate([0,0,45]) {
								for (z = [-40 : 4 : 40]) { 
									//translate([-40,z,0.25]) cube([80,1,0.25]);
									translate([z,-40,0]) cube([1,80,0.25]);
								}
							}

							translate([0,0,-1]) base(247, 22, 3);
						}
					}

					translate([0,0,5.01]) {
						difference() {
							base(213, 16, (3));
							translate([0,0,-0.01]) base(200, 14, (3.02));
						}
					}
					 
					translate([0,0,-10]) difference() {
						translate([0,0,0]) base(270, 25, 3);
						translate([0,0,-1]) base(245, 20, 5);	
					}
				}
	
				rotate([0,0,180]) translate([-11,0,-5]) cube([22,30,5]);
			}
	
			translate([26,0,9.02]) cap_socket(14, 5, 1);
		}

		translate([26,0,5]) cylinder(h = (20), r = 11, center = false, $fn = 100);
	}
}

//base_cap();
//translate([0,0,-40]) ring(250,245, 24,20, 12);

rotate([180,0,0]) translate([26,0,30]) top_cap(14, 5, 1);
