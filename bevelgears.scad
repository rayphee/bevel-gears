// Parametric Gears
// by wayland
// http://www.thingiverse.com/thing:2085

// General Parameters

basediameter = 16;   // pitch diameter of widest part 
depth = 3;           // depth of the gear
holediam = 1;        // diameter of center hole
teethnumber = 20;    // number of teeth
toothwidth = 1;      // width of teeth
addendum = 1/2;      // addendum
dedendum = 1/2;      // dedendum
toothshape = 0;   // how much of the tooth is triangular			                // for no triangles, make it 0
				 // otherwise it should be a fraction
centercircles = 0;   // number of center circles
				 // if you don't want any, put 0
				 // they are radially centered
centercircdiam = 2;  // diameter of center circles


//Bevel Parameters

degrees = 60;        // base angle of the gear
				 // 90 for a regular spur gear
				 // negative numbers are possible
extendbevel = 0;     // creates a spur top for bevel gears 
				 // only works if rbasediameter = 0
				 // 1 is on, 0 is off
bdepth = 3;          // thickness of extended bevel 
basedepth = 2;       // depth of the flat base at the bottom
				 // to turn it off, just make it 0

//Rome Gear Parameters:

rbasediameter = 0;   // pitch diameter of widest part
				 // to turn Rome gear off, make it 0
rdegrees = 90;       // base angle
rdepth = 2;          // thickness
rteeth = 10;         // number of teeth
rtwidth = 1;         // tooth width
raddendum = 1/4;     // addendum
rdedendum = 1/4;     // dedendum
rtoothshape = 1;

/*---------------------------------------------------------*/

// Modules

module gear (diam1, thick, angle, ded, add, twidth, tnumber, toothfraction)
 {

	//Trig to find top diameter:

	triangbase = thick / tan(angle);
	topdiameter =  (diam1 - 2 * triangbase) - ded;

	//Miscellaneous variables:

	bottomdiameter = diam1 - ded;
	howmuchistri = toothfraction * (add + ded);
	toothlength = (add + ded) - howmuchistri; 
	xthick = twidth/2;

	union() {

		difference () {

			cylinder(h = thick, r1 = bottomdiameter/2, r2 = topdiameter/2, $fn = 75, center = true);
			cylinder(h = 2*thick, r = holediam / 2, center = true, $fn = 75);
			centershape(thick, topdiameter);

			}

		}

		for ( i = [1:tnumber] ) {

			rotate( i*360/tnumber, [0, 0, 1])
			translate ([0, 0, thick / -2])

			geartooth (bottomdiameter, topdiameter, xthick, toothlength, thick, howmuchistri);

		}

}

module centershape (thick, diam) {

if (centercircles > 0) {

	for ( f = [1:centercircles] ) {

		rotate( f*360/centercircles, [0, 0, 1])
		translate ([diam/4, 0, 0 ])
		cylinder ( h = 2*thick, r = centercircdiam/2, $fn = 75, center = true);

	}

}

}

module geartooth (diam1, diam2, xthickness, tlength, zthick, point){

// Sorry... polyhedra are so messy in openSCAD
// In case you're wondering, the following polyhedra are one
// tooth. The first is rectangular, the second has triangles.

	if (point == 0) {

	polyhedron ( points = 
[[-xthickness, diam2/2, zthick], [-xthickness, tlength + diam2/2, zthick], [-xthickness, tlength + diam1/2, 0], [-xthickness, diam1/2, 0], [xthickness, diam2/2, zthick], [xthickness, tlength + diam2/2, zthick], [xthickness, tlength + diam1/2, 0], [xthickness, diam1/2, 0]
], triangles = [[0,2,1], [0,3,2],[3,0,4],[1,2,5],[0,5,4],[0,1,5],[5,2,6],[7,3,4],[4,5,6],[4,6,7],[6,2,7],[2,3,7]]);

	}

	if (point > 0 ) {

		polyhedron ( points = 
[[-xthickness, diam2/2, zthick], [-xthickness, tlength + diam2/2, zthick], [-xthickness, tlength + diam1/2, 0], [-xthickness, diam1/2, 0], [xthickness, diam2/2, zthick], [xthickness, tlength + diam2/2, zthick], [xthickness, tlength + diam1/2, 0], [xthickness, diam1/2, 0],[0, tlength + diam2/2 + point, zthick],[0, tlength + diam1/2 + point, 0]
], triangles = [[0,2,1], [0,3,2],[3,0,4],[1,2,8],[0,5,4],[0,1,5],[5,9,6],[7,3,4],[4,5,6],[4,6,7],[6,2,7],[2,3,7],[1,8,5],[2,6,9],[2,9,8],[5,8,9],]);

	}

}
/*---------------------------------------------------------*/
gear (basediameter, depth, degrees, dedendum, addendum, toothwidth, teethnumber, toothshape);

if (rbasediameter > 0) {

	translate ([0, 0, depth/2 + rdepth/2])
	gear (rbasediameter, rdepth, rdegrees, rdedendum, raddendum, rtwidth, rteeth, rtoothshape);

}

//More trig to find top diameter:

	triangbase = depth / tan(degrees);
	topdiameter =  (basediameter - 2 * triangbase);

if (rbasediameter == 0 && extendbevel == 1) {

	translate ([0, 0, depth/2 + bdepth/2])
	gear (topdiameter, bdepth, 90, dedendum, addendum, toothwidth, teethnumber);

}


