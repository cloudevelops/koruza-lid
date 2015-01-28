
module comlid() {
	// Define main variables for dimensions of the lid 
	lid_o_w=100; // outer width
	lid_o_t=3; // thickness of the outer part
	lid_i_w=95.5; // inner width
	lid_i_t=11; // inner depth

	// Define variables for the shape of the circuit cutout
	pcb_w=51.5;
	pcb_l=67;
	pcb_t=14;
	pcb_usb_w=12;
	pcb_usb_l=32;
	pcb_usb_t=10;
	pcb_usb_off_c=10;

	// create the lid as a module
	module lid(){
		translate([0,0,lid_o_t/2])
		cube(size=[lid_o_w,lid_o_w,lid_o_t], center=true);
		translate([0,0,lid_i_t/2+lid_o_t])
		cube(size=[lid_i_w,lid_i_w,lid_i_t], center=true);
	}

	// create cutouts for the screws of the mount inside koruza
	module screw_caps(){
		translate([-lid_i_w/2,33,17])
		rotate(a=[0,90,0])
		cylinder(h=4,r=7,center=true,$fn=20);
		translate([-lid_i_w/2,-33,17])
		rotate(a=[0,90,0])
		cylinder(h=4,r=7,center=true,$fn=20);
	}

	// create the PCB object
	module pcb(){
		cube(size=[pcb_w,pcb_l,pcb_t], center=true);
		translate([0,pcb_l/2-20,0])
		cube(size=[pcb_w+4,10,pcb_t], center=true);
		translate([-5,pcb_l/2+3,0])
		cylinder(h=pcb_t,r=1.5,center=true,$fn=20);
		translate([0,-(pcb_l/2+3),0])
		cylinder(h=pcb_t,r=1.5,center=true,$fn=20);
		translate([pcb_usb_off_c,pcb_l/2+pcb_usb_l/2,0])
		cube(size=[pcb_usb_w,pcb_usb_l,pcb_usb_t], center=true);//USB
		translate([pcb_usb_off_c,pcb_l-3,0])
		cylinder(h=pcb_usb_t,r=pcb_usb_w/2,center=true,$fn=20);
	}

	// create the lid as a difference of the the main part and cutouts and screws
	// for development and debugging change difference to union, blue parts are what will be cut out
	difference(){
		// this is the part we are cutting things from
		lid();
		color("blue")
		// cut away space for screw caps
		//screw_caps();
		// position and cut away the space for the PCB
		color("blue")
		translate([4,-6,lid_o_t+pcb_t/2-1])
		rotate(a=[0,0,53])
		color("blue")
		//pcb();
		// position and cut away the holes for the screw and nuts
		// since it is symmetric, treating it as such
		color("blue")
		for(x=[0,180]){
			rotate(a=[0,0,x])
			translate([0,-lid_o_w/2,lid_o_t+5.5])
			rotate(a=[-90,-90,180])
			screw_din912_nut_din562(l=12,d=3,nut_depth=5,fit=1.2);
		}
	}
}


difference(){
	comlid();
	translate([-2,31,-0.5]) cylinder(r = 11.5, h = 15);
	translate([-31,13,-0.5]) cylinder(r = 11.5, h = 15);
	translate([-2,31,-0.5]) cylinder(r = 15.5, h = 6.5);
	translate([-31,13,-0.5]) cylinder(r = 15.5, h = 6.5);
	translate([-27,-45,4]) cube([8,41,11]);
}

module router() {
	color("red")
	translate([-5,-47,14]) cube([52,52,2]);
	color("aqua")
	translate([15,-13,16]) cube([32,20,10]);
	color("lime")
	translate([0,-3,16]) cube([10,10,5]);
	color("white")
	translate([-7,-13,16]) cube([6,7,3]);
}

module convert() {
	color("black")
	translate([-27,-45,4]) cube([8,41,30]);
	color("teal")
	translate([-45,-45,34]) cube([44,41,2]);
	
}

module conector() {
	color("black")
	translate([-2,31,6]) cylinder(r = 11, h = 14.5);
	color("black")
	translate([-31,13,6]) cylinder(r = 11, h = 14.5);
	color("black")
	translate([-2,31,-30]) cylinder(r = 15, h = 36);
	color("black")
	translate([-31,13,-30]) cylinder(r = 15, h = 36);
	color("green")
	translate([-2,31,14]) cylinder(r = 15, h = 5);
	color("green")
	translate([-31,13,14]) cylinder(r = 15, h = 5);
	color("black")
	translate([-2,31,20]) sphere(r = 9);
	color("black")
	translate([-31,13,20]) sphere(r = 9);
	color("black")
	translate([-2,31,20]) cylinder(r = 2, h = 50);
	color("black")
	translate([-31,13,20]) cylinder(r = 2, h = 50);
}

router();
convert();
conector();
