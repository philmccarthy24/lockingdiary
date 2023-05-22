$fn=50;

servo_gap = 5;
pcb_dims = [95,70,1.2];
servo_dims = [12.5,32.5,33];
servo_enclosure_thickness = 2;

assembly();

module assembly() {
    //pcb();
    
    //servo();
    //diary();
    
    fascia();
    
}


module curve_edge_rectangle(dims) {
    hull() {
        translate([dims.y/2,dims.y/2]) circle(d=dims.y);
        translate([dims.y,0]) square([dims.x-dims.y,dims.y]);
    }
}

// 13 from right
// 3.5 from top
// 47 x 58 // base is 5.3 above pcb bottom
module fascia() {
    
    // main profile
    difference() {
        union() {
            main_fascia_profile();
            
            // section of servo housing connected to fascia
            translate([pcb_dims.x,(pcb_dims.y-servo_dims.y)/2-servo_enclosure_thickness,0]) 
    curved_top_cube([servo_dims.x+servo_enclosure_thickness*2+servo_gap,servo_dims.y+servo_enclosure_thickness*2,8], 2);
        }
            
        
        ///// cutouts
        
        // servo header joiner cutout
        translate([pcb_dims.x-0.1, 11.5, 0.25]) servo_header_joiner_cutout();
        
        // pcb board cutout with slop
        translate([-0.2,-0.2,0]) cube([pcb_dims.x+0.2,pcb_dims.y+0.4,pcb_dims.z]);
        
        // servo with slop
        translate([pcb_dims.x+servo_gap+servo_enclosure_thickness-0.2,((pcb_dims.y-servo_dims.y)/2)-0.2,-servo_dims.z+1]) cube([servo_dims.x+0.4,servo_dims.y+0.4,servo_dims.z]);
        
        // m5 chicago screw cutouts
        translate([5,35.5,-1]) cylinder(d=6,h=15);
        translate([pcb_dims.x-5,pcb_dims.y-5.5,-1]) cylinder(d=6,h=15); // 5.5 from top edge
        translate([pcb_dims.x-5,5.5,-1]) cylinder(d=6,h=15);
        
        // servo socket is 12mm wide
        translate([pcb_dims.x-9,28,0]) cube([9+servo_gap+servo_dims.x+servo_enclosure_thickness+0.2,12,7]);
        // 5mm channel for servo cable
        translate([pcb_dims.x+servo_gap+servo_enclosure_thickness+((servo_dims.x-5)/2)-0.2,((pcb_dims.y-servo_dims.y)/2)-0.2,0]) cube([5,servo_dims.y/2,3]);
        
        
        // keypad base cutout
    translate([10+1,0,-2]) cube([pcb_dims.x-10-10-1,pcb_dims.y,5+2]); // at 10.5mm in from right edge, we're 5mm high, so come out to 10 from edge
        
        // keypad cutout
        translate([35,8.5,0]) curved_cube([47,58,7], 3);
        
        
        
        ////////////
        // left hand side, 6mm clearance needed from pcb bottom, from 10mm from pcb left edge
        
        // RGB LED is 6.5, 3.5 from pcb top, 28 from left edge
        translate([28,pcb_dims.y-3.5,-1]) cylinder(h=15, d=6.5);
        
        
        // power socket
        cube([9,9,7]);
        
        // hole for power cable
        translate([-10,4,1.8+3.5/2]) rotate([0,90,0])
        hull() {
            cylinder(h=15,d=3.5);
            translate([10,0,0]) cylinder(h=15,d=3.5);
        }
    };
    
    
    
}

module main_fascia_profile() {
    hull() {
        translate([-5,-5,0]) curved_cube([pcb_dims.x+5,pcb_dims.y+5*2,0.1],5,[false,true,false,true]);
        translate([-1,-1,0]) cube([pcb_dims.x+1,pcb_dims.y+2,2]);
    }
    
    // servo socket cover section
    intersection() {
        translate([pcb_dims.x-10,11.5,1.75]) scale([1,1.5,1]) rotate([90,0,90]) linear_extrude(10) import("servo_socket_profile.svg");
        
        //translate() rotate([-90,0,0]) cylinder(h=(30*1.5)+2,r=3);
        translate([pcb_dims.x-10,11.5-1,2]) mirror([0,1,0]) rotate([90,0,0]) curved_cube([10,6,(30*1.5)+2],2.5,[true,true,false,true]);
    }
    
    // joining section to servo housing
    translate([pcb_dims.x,(pcb_dims.y-servo_dims.y)/2-servo_enclosure_thickness,0]) cube([servo_gap,servo_dims.y+servo_enclosure_thickness*2,8]);
    
    
    // keyboard base - 6mm high. hopefully this is enough to house MCU as well
    translate([10,0,1]) 
    minkowski() {
        sphere(r=1);
        cube([pcb_dims.x-10-10,pcb_dims.y,4]); // at 10.5mm in from right edge, we're 5mm high, so come out to 10 from edge
    };
    
    translate([-8,-3.5,0])
    power_socket_blister();
}

module power_socket_blister()
{
    // power socket blister
    // 10 x , 12mm wide, 8 high, 7 clearance
    
    difference() {
        translate([3,3])
        minkowski() {
            sphere(r=3);
            hull() {
            linear_extrude(0.1) curve_edge_rectangle([15,10]);
        translate([4,2,8-0.1-3]) linear_extrude(0.1) curve_edge_rectangle([11,6]);
            }
        }
        translate([-1,-1,-5]) cube([25,25,5]);
    }
}

// the smooth curve to top of servo column
module servo_header_joiner_cutout() {
    difference() {
        cube([31,45,1.6+31]);
        
        union() {
            translate([0,0,1.8]) {
                translate([0,30,30.7]) rotate([-90,0,0]) rotate_extrude(angle=90) translate([31,-30]) rotate([0,0,90]) scale([1.5,1]) import("servo_socket_profile.svg");
            }
            difference() {
                cube([31,45,1.6+31]);
                translate([0, -0.5, 31+1.6]) rotate([-90,0,0]) cylinder(h=46,d=62);
            }
        }
    }
    
}

// extruded rectangle with one or more rounded edges
module curved_cube(cubedims, radius,square_corners=[false,false,false,false]) {
    translate([radius,radius]) 
    linear_extrude(cubedims.z) {
        union() {
            minkowski() {
                circle(radius);
                square([cubedims.x - radius*2, cubedims.y - radius*2]);
            };
            if (square_corners[0]) {
                translate([-radius,-radius])
                square([cubedims.x/2,cubedims.y/2]);
            }
            if (square_corners[1]) {
                translate([-radius+cubedims.x/2,-radius])
                square([cubedims.x/2,cubedims.y/2]);
            }
            if (square_corners[2]) {
                translate([-radius,-radius+cubedims.y/2])
                square([cubedims.x/2,cubedims.y/2]);
            }
            if (square_corners[3]) {
                translate([-radius+cubedims.x/2,-radius+cubedims.y/2])
                square([cubedims.x/2,cubedims.y/2]);
            }
        }
    }    
}

//actual curved corners on cube top
module curved_top_cube(dims, corner_radius) {
    hull() {
        cube([dims.x,dims.y,0.1]);
        translate([corner_radius,corner_radius,dims.z-corner_radius]) sphere(r=corner_radius);
        translate([dims.x-corner_radius,corner_radius,dims.z-corner_radius]) sphere(r=corner_radius);
        translate([corner_radius,dims.y-corner_radius,dims.z-corner_radius]) sphere(r=corner_radius);
        translate([dims.x-corner_radius,dims.y-corner_radius,dims.z-corner_radius]) sphere(r=corner_radius);
    }
}

///////// for assembly
module pcb() {
    cube(pcb_dims);
}

module diary() {
    translate([-(148.5-pcb_dims.x),-(210-pcb_dims.y)/2,-26]) cube([148.5,210,26]);
}

// servo sticks up 1mm from diary top
//33 high by 12.5 wide by 32.5 long
module servo() {
    // just the footprint - the width is smaller due to screw plate on servo
    translate([pcb_dims.x+servo_gap,(pcb_dims.y-servo_dims.y)/2,-servo_dims.z+1]) cube(servo_dims);
    
}