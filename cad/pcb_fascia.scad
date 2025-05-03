use <threadlib/threadlib.scad>

$fn=200;

servo_gap = 5;
pcb_dims = [95,70,1.2];
servo_dims = [12.5,32.5,33];
servo_enclosure_thickness = 2;
lock_recess_height = 6;
diary_height = 26;
servo_pillar_footprint=[servo_dims.x+servo_enclosure_thickness*2,servo_dims.y+servo_enclosure_thickness*2];

//assembly();
print_layout();

module assembly() {
    /*
    color([0,1,0]) pcb();
    
    color([1,0,0]) servo();
    color([0,0,1])diary();
    
    fascia();
    
    translate([pcb_dims.x+servo_gap,(pcb_dims.y-servo_dims.y)/2-servo_enclosure_thickness,-servo_dims.z+1]) servo_pillar();
    */
    translate([pcb_dims.x+servo_gap,(pcb_dims.y-servo_dims.y)/2-servo_enclosure_thickness,-servo_dims.z]) servo_pillar_cap();
    
    //translate([0,0,-diary_height-7]) lock_recess_plate();
}

module print_layout() {
    //translate([0,0,servo_dims.z-1]) rotate([180,0,0]) servo_pillar();
    
    translate([-30,0,lock_recess_height]) rotate([180,0,0]) lock_recess_plate();
    
    //servo_pillar_cap();
}

// relative to pcb lower bottom edge
module lock_recess_plate() {
    slop=0.5;
    
    difference() {
        union() {
            translate([pcb_dims.x,(pcb_dims.y-50)/2,0]) curved_cube([25,50,lock_recess_height], 4, [true,false,true,false]);
            
            hull() {
                translate([pcb_dims.x-20,0,lock_recess_height-0.1]) {
                    translate([0,10,0]) cylinder(h=0.1,d=25);
                    translate([0,pcb_dims.y-10,0]) cylinder(h=0.1,d=25);
                }
                translate([pcb_dims.x-1,(pcb_dims.y-50)/2,0]) cube([2,50,lock_recess_height]);
            };
        }
        
        ///// cutouts
        
        // chicage screws
        translate([pcb_dims.x-20,0,-1]) {
            // mounting plates
            translate([0,10,0]) cylinder(h=lock_recess_height,d=10);
            translate([0,pcb_dims.y-10,0]) cylinder(h=lock_recess_height,d=10);
            
            // m5 bores
            translate([0,10,0]) cylinder(h=lock_recess_height+3,d=6);
            translate([0,pcb_dims.y-10,0]) cylinder(h=lock_recess_height+3,d=6);
        }
        
        // void for servo pillar
        translate([(pcb_dims.x+servo_gap)-slop,((pcb_dims.y-servo_pillar_footprint.y)/2)-slop,-1])
        cube([servo_pillar_footprint.x+slop*2,servo_pillar_footprint.y+slop*2,lock_recess_height+5]);
        
        // finally, the servo arm recess
        // 9mm out from servo pillar edge, 23 mm width across, reckon 1mm out from surface, a 2mm recess should be sufficient
        translate([pcb_dims.x+servo_gap-9,(pcb_dims.y-23)/2,lock_recess_height-1-3]) cube([9+2,23,3+2]);
        
    }
}

// little cap for servo pillar to hide servo when journal is open.
module servo_pillar_cap() {
    slop=0.3;
    // 1mm extra height onto pillar
    
    // pillar profile
    cube([servo_pillar_footprint.x,servo_pillar_footprint.y,1]);
    
    translate([0,servo_enclosure_thickness-slop,1])
    difference(){
        cube([servo_pillar_footprint.x-(servo_enclosure_thickness-slop), servo_dims.y+slop*2, 3]);
        
        translate([-1,2,0]) cube([servo_pillar_footprint.x-(servo_enclosure_thickness-slop)-2+1, (servo_dims.y+slop*2)-2*2, 4]);
    }
    
}

module servo_pillar() {
    
    difference() {
        // pillar profile
        cube([servo_pillar_footprint.x,servo_pillar_footprint.y,servo_dims.z-1]);
        
        // cutouts
        
        // top part of servo is 12mm wide, 23mm long, 16 mm height til servo screw plate. add 0.2 slop
        translate([servo_enclosure_thickness-0.2,servo_enclosure_thickness-0.2+((servo_dims.y-23)/2),0]) cube([servo_dims.x+0.2*2, 23+0.2*2, servo_dims.z]);
        
        // bottom part of servo
        servo_plate_height = servo_dims.z - 16;
        translate([servo_enclosure_thickness-0.2,servo_enclosure_thickness-0.2,-1]) cube([servo_dims.x+0.2*2, servo_dims.y+0.2*2,servo_plate_height + 1]);
        
        // M2 taps for servo screws - 2mm from edges in center
        translate([(servo_dims.x+servo_enclosure_thickness*2)/2,servo_enclosure_thickness-0.2+2,servo_plate_height-0.1]) tap("M2", turns=17);
        translate([(servo_dims.x+servo_enclosure_thickness*2)/2,servo_dims.y+servo_enclosure_thickness+0.2-2,servo_plate_height-0.1]) tap("M2", turns=17);
        
        // gap at bottom for servo arm
        translate([-0.1,servo_enclosure_thickness-0.2,-1]) cube([servo_enclosure_thickness*2+0.1,servo_dims.y+0.4,8+1]);
        
        // gap at top to feed connector through
        translate([-0.1,servo_enclosure_thickness-0.2+((servo_dims.y-23)/2),servo_dims.z-1-5]) cube([servo_enclosure_thickness*2+0.1,23+0.2*2,10+1]);
    }
}

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
        translate([-0.2,-0.2,0]) cube([pcb_dims.x+0.5,pcb_dims.y+0.4,pcb_dims.z]);
        
        // servo with slop - at top, servo is 23mm long (then +0.5 for slop). side screw mounts then stick out (on servo pillar)
        servo_body_length = 23 + 0.5;
        translate([pcb_dims.x+servo_gap+servo_enclosure_thickness-0.2,((pcb_dims.y-servo_body_length)/2)-0.2,-servo_dims.z+1]) cube([servo_dims.x+0.4,servo_body_length+0.4,servo_dims.z]);
        
        // m5 chicago screw cutouts
        translate([6,35.5,-1]) cylinder(d=6,h=15);
        translate([6,35.5,2]) cylinder(d=9.5,h=15);
        translate([pcb_dims.x-5,pcb_dims.y-5.5,-1]) cylinder(d=6,h=15); // 5.5 from top edge
        translate([pcb_dims.x-5,5.5,-1]) cylinder(d=6,h=15);
        
        // servo socket is 12mm wide
        translate([pcb_dims.x-9,28,0]) cube([9+servo_gap+servo_dims.x+servo_enclosure_thickness+0.2,12,7]);
        // 5mm channel for servo cable
        translate([pcb_dims.x+servo_gap+servo_enclosure_thickness+((servo_dims.x-5)/2)-0.2,((pcb_dims.y-servo_dims.y)/2)-0.2,0]) cube([5,servo_dims.y/2,3]);
        
        // keypad base cutout
    translate([10+1.5,0,-2]) cube([pcb_dims.x-10-10-1.5,pcb_dims.y,5+2]); // at 10.5mm in from right edge, we're 5mm high, so come out to 10 from edge
        
        // keypad cutout
        translate([35,8.5,0]) curved_cube([47,58,7], 3);
        
        
        ////////////
        // left hand side, 6mm clearance needed from pcb bottom, from 10mm from pcb left edge
        
        // RGB LED is 6.5, 3.5 from pcb top, 28 from left edge
        translate([28,pcb_dims.y-4,-1]) cylinder(h=15, d=6);
        
        // power socket
        translate([-2,0,0]) cube([9+2,9,7]);
        
        // hole for power cable
        translate([-12,4,1.8+4/2]) rotate([0,90,0])
        hull() {
            cylinder(h=15,d=4);
            translate([10,0,0]) cylinder(h=15,d=4);
        }
    };
}

module main_fascia_profile() {
    hull() {
        translate([-5,-5,0]) curved_cube([pcb_dims.x+5+1.5,pcb_dims.y+5*2,0.1],5,[false,true,false,true]);
        translate([-1,-1,0]) cube([pcb_dims.x+2.5,pcb_dims.y+2,2]);
    }
    
    // servo socket cover section
    intersection() {
        translate([pcb_dims.x-10,11.5,1.75]) scale([1,1.5,1]) rotate([90,0,90]) linear_extrude(10) import("servo_socket_profile.svg");
        
        translate([pcb_dims.x-10,11.5-1,2]) mirror([0,1,0]) rotate([90,0,0]) curved_cube([10,6,(30*1.5)+2],2.5,[true,true,false,true]);
    }
    
    // joining section to servo housing
    translate([pcb_dims.x,(pcb_dims.y-servo_dims.y)/2-servo_enclosure_thickness,0]) cube([servo_gap,servo_dims.y+servo_enclosure_thickness*2,8]);
    
    // keyboard base - 6mm high. Enough to house MCU as well
    translate([10.5,0,1]) 
    minkowski() {
        sphere(r=1);
        cube([pcb_dims.x-10-10.5,pcb_dims.y,4]); // at 10.5mm in from right edge, we're 5mm high, so come out to 10 from edge
    };
    
    translate([-10,-3.5,0])
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
            translate([-0.5,-1.5,0]) linear_extrude(0.1) curve_edge_rectangle([15.5,13]);
        translate([4-0.5,2,7.5-3]) linear_extrude(0.1) curve_edge_rectangle([11.5,6]);
            }
        }
        translate([-5,-5,-5]) cube([30,30,5]);
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



///////// footprints for assembly
module pcb() {
    cube(pcb_dims);
}

module diary() {
    translate([-(146.9-pcb_dims.x),-(210-pcb_dims.y)/2,-diary_height]) cube([148.5,210,26]);
}

// servo sticks up 1mm from diary top
//33 high by 12.5 wide by 32.5 long
module servo() {
    // just the footprint - the width is smaller due to screw plate on servo
    translate([pcb_dims.x+servo_gap+servo_enclosure_thickness,(pcb_dims.y-servo_dims.y)/2,-servo_dims.z+1]) cube(servo_dims);
    
}



///////// utility ////////////

module curve_edge_rectangle(dims) {
    hull() {
        translate([dims.y/2,dims.y/2]) circle(d=dims.y);
        translate([dims.y,0]) square([dims.x-dims.y,dims.y]);
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