$fn=30;

module rcube(size=[1,1,1], center=false, radius=1, debug=false,
		bf=true, br=true, bb=true, bl=true,
		cfl=true, cfr=true, cbr=true, cbl=true,
		tf=true, tr=true, tb=true, tl=true) {		
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

module rInnerTopCube(size=[1,1,1], center=false, radius=1, debug=false,
		f=true, r=true, b=true, l=true) {
	module roundEdge(length, translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					translate([(radius)/2 + 1/4,(radius)/2 + 1/4,0]) {
						cube([radius/2 + 1, radius/2 + 1, length], center=true);
					}
					cylinder(h=length + 2, r=radius, center=true);
				}
			}
		}
	}
	module roundCorner(translation=[0,0,0], rotation=[0,0,0]) {
		translate(translation) {
			rotate(rotation) {
				difference() {
					cube([radius + 1,radius + 1,radius + 1]);
					union() {
						translate([0,-1,0]) {
							rotate([270,0,0]) {
								cylinder(h=radius + 3, r=radius);
							}
						}
						translate([-1,,0]) {
							rotate([0,90,0]) {
								cylinder(h=radius + 3, r=radius);
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
		
		union() {
			// edges
			if(f) {
				roundEdge(x,[0,-y/2 - radius,z/2-radius],[0,270,0]);
			}
			if(r) {
				roundEdge(y,[x/2 + radius,0,z/2-radius],[90,270,0]);
			}
			if(b) {
				roundEdge(x,[0,y/2 + radius,z/2-radius],[180,270,0]);
			}
			if(l) {
				roundEdge(y,[-x/2 - radius,0,z/2-radius],[270,270,0]);
			}
			// corners
			if(f && r) {
				roundCorner([x/2 + radius,-y/2 - radius,z/2-radius], [0,0,90]);
			}
			if(r && b) {
				roundCorner([x/2 + radius,y/2 + radius,z/2-radius], [0,0,180]);
			}
			if(b && l) {
				roundCorner([-x/2 - radius,y/2 + radius,z/2-radius], [0,0,270]);
			}
			if(l && f) {
				roundCorner([-x/2 - radius,-y/2 - radius,z/2-radius], [0,0,0]);
			}
		}
	}
}

debug = false;
difference() {
	rcube([14,12,10], debug=debug, center=true);
	union() {
		translate([0,0,1]) {
			rcube([10,8,11], debug=debug, center=true);
		}
		rInnerTopCube([10,8,10], debug=false, center=true);
	}
}
