$fn=100;

module rcylinder(h = 1, r1 = 1, r2 = 1, center = false, radius = 1, debug = false, radius1, radius2) {
	// define all values
	radius1 = radius1 == undef ? radius : radius1;
	radius2 = radius2 == undef ? radius : radius2;
	
	function angle(h, r) = atan2(h, r);
	function differenceSquareX(radius, angle) = (radius / (tan(angle / 2)));
	function differenceSquareY(differenceSquareX, angle) = differenceSquareX * cos(90 - angle);

	module rCylinderFactory(h, r1, r2, center, radius1, radius2) {
		union() {
			difference() {
				cylinder(h = h, r1 = r1, r2 = r2, center = center);
				if (radius1 > 0) {
					roundEdge(h, r1, r2, radius1);
				}
				if (radius2 > 0) {
					translate([0,0,h]) {
						rotate([0,180,0]) {
							roundEdge(h, r2, r1, radius2);
						}
					}
				}
			}
		}
	}

	module roundEdge(h, rThis, rOther, radius, convexity = 10) {
		a = angle (h, rThis - rOther);
		dSX = differenceSquareX(radius, a);
		dSY = differenceSquareY(dSX, a);
		
		// if round edge is smaller than cylinder radius
		if (rThis - dSX >= 0) {
			// make a round edge
			_stdRoundEdge(rThis, radius, convexity, dSX, dSY);
		} else {
			// put a sphere on top of the cylinder instead of a round edge
//			_sphereRoundEdge();
		}
	}
	
	module _stdRoundEdge(rThis, radius, convexity = 10, dSX, dSY) {
		rotate_extrude(convexity = convexity) {
			translate([rThis - dSX, radius, 0]) {
				difference() {
					translate([(dSX + 1)/2, ((dSY - 1)/2) - radius, 0]) {
						square([dSX + 1, dSY + 1], center = true);
					}
					circle(r = radius);
				}
			}
		}
	}

	if(debug) {
		cylinder(h = h, r1 = r1, r2 = r2, center = center);
	} else {
		rCylinderFactory(h = h, r1 = r1, r2 = r2, center = center, radius1 = radius1, radius2 = radius2);
	}
}

rcylinder(h=25, r1=3, r2=8, radius1 = 2, radius2 = 4, center=false, debug=false);

