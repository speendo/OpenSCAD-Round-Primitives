$fn=20;

module rcube(size=[1,1,1], center=false, radius=1, debug=false,
		bo, ce, to,
		fr, ri, ba, le,
		bf, br, bb, bl,
		cfl, cfr, cbr, cbl,
		tf, tr, tb, tl) {
		
	// define all values
	bo = bo == undef ? true : bo;
	ce = ce == undef ? true : ce;
	to = to == undef ? true : to;
	
	fr = fr == undef ? true : fr;
	ri = ri == undef ? true : ri;
	ba = ba == undef ? true : ba;
	le = le == undef ? true : le;
	
	bf = bf == undef ? (bo && fr) : bf;
	br = br == undef ? (bo && ri) : br;
	bb = bb == undef ? (bo && ba) : bb;
	bl = bl == undef ? (bo && le) : bl;
	cfl = cfl == undef ? (ce && fr && le) : cfl;
	cfr = cfr == undef ? (ce && fr && ri) : cfr;
	cbr = cbr == undef ? (ce && ba && ri) : cbr;
	cbl = cbl == undef ? (ce && ba && le) : cbl;
	tf = tf == undef ? (to && fr) : tf;
	tr = tr == undef ? (to && ri) : tr;
	tb = tb == undef ? (to && ba) : tb;
	tl = tl == undef ? (to && le) : tl;
	
	module roundEdge(length, translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					translate([(radius)/2 + 1/4,(radius)/2 + 1/4,0]) {
						cube([radius/2 + 1, radius/2 + 1, length + 4], center=true);
					}
					cylinder(h=length + 2, r=radius, center=true);
				}
			}
		}
	}
	module roundFullCorner(translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					cube([radius/2 + 1, radius/2 + 1, radius/2 + 1]);
					sphere(r=radius);
				}
			}
		}			
	}
	
	if(debug) {
		cube(size=size, center=center);
	} else {
	
		translation = center ? [0,0,0] : size / 2;
	
		translate(translation) {
	
			difference() {
				cube(size=size, center=true);
		
				union() {
					x = size[0];
					y = size[1];
					z = size[2];
			
					// edges
					if(bf) {
						roundEdge(x,[0,-y/2 + radius,-z/2 + radius],[180,90,0]);
					}
					if(br) {
						roundEdge(y,[x/2 - radius,0,-z/2 + radius],[90,90,0]);
					}
					if(bb) {
						roundEdge(x,[0,y/2 - radius,-z/2 + radius],[0,90,0]);
					}
					if(bl) {
						roundEdge(y,[-x/2 + radius,0,-z/2 + radius],[90,180,0]);
					}
					if(cfl) {
						roundEdge(z,[-x/2 + radius,-y/2 + radius,0],[0,0,180]);
					}
					if(cfr) {
						roundEdge(z,[x/2 - radius,-y/2 + radius,0],[0,0,270]);
					}
					if(cbl) {
						roundEdge(z,[-x/2 + radius,y/2 - radius,0],[0,0,90]);
					}
					if(cbr) {
						roundEdge(z,[x/2 - radius,y/2 - radius,0],[0,0,0]);
					}
					if(bf) {
						roundEdge(x,[0,-y/2 + radius,-z/2 + radius],[180,90,0]);
					}
					if(tf) {
						roundEdge(x,[0,-y/2 + radius,z/2 - radius],[180,270,0]);
					}
					if(tr) {
						roundEdge(y,[x/2 - radius,0,z/2 - radius],[270,270,0]);
					}
					if(tb) {
						roundEdge(x,[0,y/2 - radius,z/2 - radius],[0,270,0]);
					}
					if(tl) {
						roundEdge(y,[-x/2 + radius,0,z/2 - radius],[270,180,0]);
					}

					// corners
					if(bf && bl && cfl) {
						roundFullCorner([-x/2 + radius,-y/2 + radius,-z/2 + radius], [180,90,0]);
					}
					if(bf && br && cfr) {
						roundFullCorner([x/2 - radius,-y/2 + radius,-z/2 + radius], [180,0,0]);
					}
					if(bb && br && cbr) {
						roundFullCorner([x/2 - radius,y/2 - radius,-z/2 + radius], [0,90,0]);
					}
					if(bb && bl && cbl) {
						roundFullCorner([-x/2 + radius,y/2 - radius,-z/2 + radius], [0,180,0]);
					}
					if(tf && tl && cfl) {
						roundFullCorner([-x/2 + radius,-y/2 + radius,z/2 - radius], [0,0,180]);
					}
					if(tf && tr && cfr) {
						roundFullCorner([x/2 - radius,-y/2 + radius,z/2 - radius], [0,0,270]);
					}
					if(tb && tr && cbr) {
						roundFullCorner([x/2 - radius,y/2 - radius,z/2 - radius], [0,0,0]);
					}
					if(tb && tl && cbl) {
						roundFullCorner([-x/2 + radius,y/2 - radius,z/2 - radius], [0,0,90]);
					}
				}
			}
		}
	}
}

module rInnerTopCube(size=[1,1,1], center=false, radius=1, radius1, radius2, debug=false,
		f=true, r=true, b=true, l=true, convexity=10, $fn=$fn) {

	// define radius1 and radius2
	radius1 = radius1 == undef ? radius : radius1;
	radius2 = radius2 == undef ? radius : radius2;

	module roundEdge(length, translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					translate([-1/2,0,0]) {
						cube([radius1 + 1, 2*radius1, length], center=true);
					}
					translate([radius1/2,-radius1,0]) {
						cylinder(h=length, r=radius1, center=true);
					}
				}
			}
		}
	}
	module roundCorner1(translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				if (radius1 > radius2) {
					difference() {
						cube([2*radius1 + 1,2*radius1 + 1,radius1 + 1]);
						union() {
							translate([0,-1,0]) {
								rotate([270,0,0]) {
									cylinder(h=2*radius1 + 3, r=radius1);
								}
							}
							translate([-1,,0]) {
								rotate([0,90,0]) {
									cylinder(h=2*radius1 + 3, r=radius1);
								}
							}
						}
					}
				}
			}
		}
	}
	module roundCorner2(translation=[0,0,0], rotation=[0,0,0]) {
		if (radius2 > 0) {
			translate(translation) {
				rotate(rotation) {
					intersection() {
						translate([-radius1-radius2,-radius1-radius2,0]) {
							cube([radius1+radius2+1,radius1+radius2+1,radius2 + 1]);
						}
						difference() {
							translate([0,0,-1]) {
								cylinder(h=radius2 + 3, r=radius1+radius2);
							}
							rotate_extrude(convexity=convexity) {
								translate([radius1+radius2,0,0]) {
									circle(r=radius1, $fn=$fn);
								}
							}
						}
					}
				}
			}
		}
	}
	
	function pos1(pos) = pos > 0 ? pos + radius1 : pos - radius1;
	function pos2(pos) = pos > 0 ? pos - radius2 : pos + radius2;

	module roundCorner(translation=[0,0,0], rotation=[0,0,0]) {
		intersection() {
			roundCorner1([pos1(translation[0]), pos1(translation[1]), translation[2]], rotation);
			roundCorner2([pos2(translation[0]), pos2(translation[1]), translation[2]], rotation);
		}
	}

	function rFR() = (f && r == true) ? true : false;
	function rRB() = (r && b == true) ? true : false;
	function rBL() = (b && l == true) ? true : false;
	function rLF() = (l && f == true) ? true : false;
	
	function longerRadius() = radius1 > radius2 ? radius1 : radius2;
	
	function edgeLength(length, c1, c2) = (c1 == true) ? ((c2 == true) ? length - 2*longerRadius() : length - longerRadius()) : ((c2 == true) ? length - longerRadius() : length);
	
	function edgePosition(c1, c2) = (c1 == c2) ? 0 : ((c1 == true) ? 1*longerRadius()/2 : -longerRadius()/2);

	if(!debug) {
		x = size[0];
		y = size[1];
		z = size[2];
		
		union() {
			// edges
			if(f) {
				roundEdge(edgeLength(x, rFR(), rLF()),[edgePosition(rLF(), rFR()),-y/2,(z-radius1)/2],[0,90,0]);
			}
			if(r) {
				roundEdge(edgeLength(y, rFR(), rRB()),[x/2,edgePosition(rFR(), rRB()),(z-radius1)/2],[270,90,0]);
			}
			if(b) {
				roundEdge(edgeLength(x, rRB(), rBL()),[edgePosition(rBL(), rRB()),y/2,(z-radius1)/2],[180,90,0]);
			}
			if(l) {
				roundEdge(edgeLength(y, rBL(), rLF()),[-x/2,edgePosition(rLF(), rBL()),(z-radius1)/2],[90,90,0]);
			}
			// corners
			if(rFR()) {
				roundCorner([x/2,-y/2,z/2-radius1], [0,0,90]);
			}
			if(rRB()) {
				roundCorner([x/2,y/2,z/2-radius1], [0,0,180]);
			}
			if(rBL()) {
				roundCorner([-x/2,y/2,z/2-radius1], [0,0,270]);
			}
			if(rLF()) {
				roundCorner([-x/2,-y/2,z/2-radius1], [0,0,0]);
			}
		}
	}
}

debug = false;
difference() {
	rcube([14,12,10], radius=1, ce=false, center=true, debug=debug);
	union() {
		translate([0,0,1]) {
			rcube([10,8,9], radius=2.5, bo=true, to=false, fr=false, le=false, debug=debug, center=true);
		}
		rInnerTopCube([10,8,10], f=false, l=false, radius1 = 1, radius2=2.5, debug=debug, center=true);
	}
}

