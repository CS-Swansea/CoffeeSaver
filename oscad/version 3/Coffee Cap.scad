use <../libraries/threads.scad>
use <../libraries/text.scad>

module top_cap(rad, thick, pad) {
	intersection() {
		difference() {
			cylinder(h = (pad + thick+3), r = rad+2, center = false, $fn = 8);

			union() {
				translate([0,0,-2]) cylinder(h = pad+2.01, r = rad, center = false, $fn = 100);
				translate([0,0,pad]) metric_thread((rad * 2.0), 2, thick, n_starts = 1, internal = true);
				translate([0,0,(pad + thick-0.01)]) cylinder(h = 1.05, r = rad-1, center = false, $fn = 100);
			}
		}
		translate([0,0,-1]) cylinder(h = (pad + thick+4), r = rad+1.5, center = false, $fn = 1000);
	}
}

rotate([180,0,0]) top_cap(14, 5, 1); 