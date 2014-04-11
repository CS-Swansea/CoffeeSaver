use <Coffee Body.scad>
use <Coffee Cap.scad>
use <Coffee Clip.scad>

complete(260);

capTrans = calcSideLength(260, 26) / 2.0;
translate([capTrans,0, 30]) top_cap(14, 5, 1); 

translate([80,0, -10]) rotate([0,0,90]) clip(10, 260, 8); 
translate([-80,0, -10]) rotate([0,0,-90]) clip(10, 260, 8); 