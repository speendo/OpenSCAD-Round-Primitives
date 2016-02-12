$fn=30;

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
		f=true, r=true, b=true, l=true, convexity=10, $fn=50) {

	// define radius1 and radius2
	radius1 = radius1 == undef ? radius : radius1;
	radius2 = radius2 == undef ? radius : radius2;

	module roundEdge(length, translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					translate([-1/2,0,0]) {
						cube([radius1 + 1, 2*radius1, length - 2*radius1], center=true);
					}
					translate([radius1/2,-radius1,0]) {
						cylinder(h=length-2*radius1, r=radius1, center=true);
					}
				}
			}
		}
	}
	module roundCorner1(translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
#					cube([2*radius1 + 1,2*radius1 + 1,radius1 + 1]);
					union() {
						translate([0,-1,0]) {
							rotate([270,0,0]) {
								cylinder(h=radius1 + 3, r=radius1);
							}
						}
						translate([-1,,0]) {
							rotate([0,90,0]) {
								cylinder(h=radius1 + 3, r=radius1);
							}
						}
					}
				}
			}
		}
	}
	module roundCorner2(translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					translate([-2*radius,-2*radius,0]) {
						cube([1.5*radius2 + 1,1.5*radius2 + 1,radius2]);
					}
					difference() {
						translate([0,0,-1]) {
							cylinder(h=radius2 + 3, r=2*radius2);
						}
						rotate_extrude(convexity=convexity) {
							translate([2*radius2,0,0]) {
								circle(r=radius2, $fn=$fn);
							}
						}
					}
				}
			}
		}
	}

	if(!debug) {
		x = size[0];
		y = size[1];
		z = size[2];
		
		difference() {
			union() {
				// edges
				if(f) {
					roundEdge(x,[0,-y/2,(z-radius1)/2],[0,90,0]);
				}
				if(r) {
					roundEdge(y,[x/2,0,(z-radius1)/2],[270,90,0]);
				}
				if(b) {
					roundEdge(x,[0,y/2,(z-radius1)/2],[180,90,0]);
				}
				if(l) {
					roundEdge(y,[-x/2,0,(z-radius1)/2],[90,90,0]);
				}
				// corners1
				if(f && r) {
//					roundCorner1([x/2 + radius1,-y/2 - radius1,z/2-radius1], [0,0,90]);
					roundCorner2([x/2 - radius1,-y/2 + radius1,z/2-radius1], [0,0,90]);
				}
				if(r && b) {
//					roundCorner1([x/2 + radius1,y/2 + radius1,z/2-radius1], [0,0,180]);
				}
				if(b && l) {
//					roundCorner1([-x/2 - radius1,y/2 + radius1,z/2-radius1], [0,0,270]);
				}
				if(l && f) {
//					roundCorner1([-x/2 - radius1,-y/2 - radius1,z/2-radius1], [0,0,0]);
				}
			}
			// corners2
			if(f && r) {
				roundCorner2([x/2 - radius1,-y/2 + radius1,z/2-radius1], [0,0,90]);
			}
			if(r && b) {
				roundCorner2([x/2 - radius1,y/2 - radius1,z/2-radius1], [0,0,180]);
			}
			if(b && l) {
				roundCorner2([-x/2 + radius1,y/2 - radius1,z/2-radius1], [0,0,270]);
			}
			if(l && f) {
				roundCorner2([-x/2 + radius1,-y/2 + radius1,z/2-radius1], [0,0,0]);
			}
		}
	}
}

radius = 2;

debug = true;
difference() {
	rcube([14,12,10], radius=radius, debug=debug, center=true);
	union() {
		translate([0,0,1]) {
			rcube([10,8,9], radius=radius, bo=false, to=false, debug=false, center=true);
		}
		rInnerTopCube([10,8,10], radius=radius, debug=false, center=true);
	}
}


