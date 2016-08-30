$fn=100;

module rcylinder($fn = 0, $fa = 12, $fs = 2, h = 1, r1 = 1, r2 = 1, center = false, radius = 1, debug = false, radius1, radius2) {
	// define all values
	radius1 = radius1 == undef ? true : radius;
	radius2 = radius2 == undef ? true : radius;
	
	function angle(h, r) = atan2(h, r);
	function differenceSquareX(radius, angle) = (radius / (tan(angle / 2)));
	function differenceSquareY(differenceSquareX, angle) = differenceSquareX * cos(90 - angle);
	
	if(debug) {
		cylinder($fn = $fn, $fa = $fa, $fs = $fs, h = h, r1 = r1, r2 = r2, center = center);
	} else {
		union() {
			alpha = angle(h, r1);
			x = differenceSquareX(radius, alpha);
			y = differenceSquareY(x, alpha);
			
			difference() {
				cylinder($fn = $fn, $fa = $fa, $fs = $fs, h = h, r1 = r1, r2 = r2, center = center);
				rotate_extrude(convexity = 50, $fn = 50) {// TODO
					translate([r1 - x, radius, 0]) {
						difference() {
							translate([(x + 1)/2,((y - 1) /2) - radius,0]) {
								square([x + 1, y + 1], center=true);
							}
							circle(r = radius, $fn = 70); // TODO
						}
					}
				}
			}
		}
	}
}

rcylinder($fn = 200, h=12, r1=5, r2=0, radius= 2, center=false, debug=false);
