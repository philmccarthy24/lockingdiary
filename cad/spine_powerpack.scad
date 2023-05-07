$fn=200;

// TODO: 
// way to print this is to split into two, just after neg terminal, to cut down on amount of support material required. Can then print vertically.

// 25 breadth x 212 len
// aaa 44.3 long = 133 for 3. + 5 mm for spring compression
// 10.5 d

book_length = 212;
spine_height = 25;
aaa_length = 44.3;
aaa_diam = 10.5;
spring_slop = 8;
aaa_diam_slop = 5;

bulkhead_thickness = 2;
battery_inlay_length = (aaa_length*3)+spring_slop;
neg_bulkhead_point = battery_inlay_length+10+5+bulkhead_thickness;


printing_arrangement();
//assembly();

module printing_arrangement() {
    // -ve end of power pack, put vertically for no supports
    rotate([0,-90,0])
    translate([-(battery_inlay_length+10),0,0])
    difference() {
        powerpack_base();
        translate([-1,0,0]) rotate([0,90,0]) cylinder(h=battery_inlay_length+10+1,d=spine_height*2);
    }
    
    // +ve end of power pack, put vertically for minimal supports
    translate([0,40,0])
    rotate([0,-90,0])
    difference() {
        powerpack_base();
        translate([neg_bulkhead_point-5-2,0,0]) rotate([0,90,0]) cylinder(h=100,d=spine_height*2);
    }
    
    // -ve end insert, to be glued in place
    translate([20,0,book_length-neg_bulkhead_point-4]) rotate([0,90,0]) miniboost_insert();
    
    translate([30,40,0]) lid();
}

module assembly() {
    powerpack_base();
    translate([neg_bulkhead_point,0,0]) miniboost_insert();
    //translate([5+0.25,0,3]) rotate([0,90,0]) lid();
}


// housing for miniboost, switch and wiring that slides/glues into place
module miniboost_insert() {
    // the miniboost needs 12 x 18.
    // M2.5 screw hole is 2.5x2.5 in from top left edge. Think just gluing a small nylon standoff is acceptable/easiest.
    
    // switch dimensions:
    //20 x 4.5 screw plate
    //10.6 x 6 len by width terminal case. 5mm depth + plate (0.5 thick).
    // depth including switch itself is 8.5. so could do with being recessed by 4mm
    
    // Wago 221 is 30x18x8 - not going to fit. just solder wires instead.
    translate([0,-(spine_height-4)/2,0]) cube([book_length-neg_bulkhead_point-4,spine_height-4,1]);
    difference() {
        batt_housing_outer(book_length-neg_bulkhead_point-4,3,spine_height-4);
        // hollow out center
        translate([-0.1,0,0]) batt_housing_outer(book_length-neg_bulkhead_point-4-5+0.1,3,spine_height-6);
        // take off top, leaving rear 45 degree arch
        translate([-1,-(spine_height-4)/2,5]) {
            translate([spine_height/2,0,0]) cube([book_length-neg_bulkhead_point-4-5-spine_height/2+1,spine_height-4,spine_height]);
            translate([spine_height/2,-2,0]) rotate([0,-45,0]) cube([spine_height,spine_height,spine_height]);
        }
        // hole to mount power switch
        translate([book_length-neg_bulkhead_point-4-6,-10.6/2,spine_height/4-6/2]) cube([7,10.6,6]);
        // power switch plate - might need trimming
        translate([book_length-neg_bulkhead_point-4.5,-20/2,spine_height/4-4.5/2]) cube([1,20,4.5]);
    }
}


module powerpack_base() {
    difference() {
        batt_housing_outer(book_length,3,spine_height);
        translate([10,0,(aaa_diam+aaa_diam_slop)/2+1]) housing_inlay(battery_inlay_length,aaa_diam+aaa_diam_slop);
        
        //gap for lid.
        translate([5,0,3]) rotate([0,90,0]) lid_outer(0.1);
        
        //inside volume
        inside_volume();
        //2mm extra height/diameter at switch end
        translate([neg_bulkhead_point,0,-0.1]) batt_housing_outer(60,3,spine_height-4);
        
        // holes for M2 knurl nuts, to screw lid into
        //3.5d x 4mm len for whole fixing - so 2.75 diam for melt?
        translate([battery_inlay_length+10+5/2,0,(aaa_diam+3)-5]) cylinder(h=6,d=2.75);
        translate([5+5/2,0,(aaa_diam+3)-5]) cylinder(h=6,d=2.75);
        
        // holes for terminal wires
        translate([battery_inlay_length+10-1,3,3+1]) rotate([0,90,0]) cylinder(h=5, d=2);
        translate([5+5-3,3,3+1]) rotate([0,90,0]) cylinder(h=5, d=2);
        
        // hole for power cable egress
        translate([book_length/2,spine_height/2+1,0]) cable_egress_volume();
        
        // labels for polarity
        translate([20,-4.5,0.8]) linear_extrude(10) text("+");
    translate([neg_bulkhead_point-5-bulkhead_thickness-20,-4.5,0.75]) linear_extrude(10) text("-");
    }
    
    
    
    // additional +ve end glue support, with arc for supportless printing
    difference() {
        translate([20,-spine_height/2,0]) cube([40,spine_height,1]);
        translate([20,0,-spine_height/2]) cylinder(h=spine_height, d=spine_height-8);
    }
    
}






module cable_egress_volume() {
    rotate([90,0,0])
    linear_extrude(6)
    hull() {
        circle(d=4);
        translate([2,0]) circle(d=4);
    }
}
    

module inside_volume() {
    difference() {
        translate([2,0,-0.1]) batt_housing_outer(book_length,3,spine_height-8);
        translate([8,0,(aaa_diam+aaa_diam_slop+4)/2]) housing_inlay(battery_inlay_length+4,aaa_diam+aaa_diam_slop+4);
    }
}

module lid() {
    difference() {
        lid_outer(0, 1, 0.5);
        // holes for M2 screws
        translate([-spine_height/2-1,0,(5/2)-0.25])
        rotate([0,90,0]) {
            cylinder(h=6, d=2);
            cylinder(h=2, d=4);
        }
        translate([-spine_height/2-1,0,(aaa_length*3)+spring_slop+10-(5/2)-0.25])
        rotate([0,90,0]) {
            cylinder(h=6, d=2);
            cylinder(h=2, d=4);
        }
    }
    
}

module lid_outer(z_slop, axial_slop=0, side_slop=0) {
    linear_extrude((aaa_length*3)+spring_slop+10-side_slop)
circle_section(spine_height+z_slop,4+z_slop,30+axial_slop);
}


module batt_housing_outer(length,base_height,width){
    translate([0,-width/2,0]) cube([length,width,base_height]);
    translate([0,0,base_height])
    rotate([0,90,0]) difference() {
        cylinder(h=length, d=width);
        translate([0,-width,-1]) cube([width,width*2,length+2]);
    }
}

module housing_inlay(length,diam) {
    rotate([0,90,0]) hull() {
        cylinder(h=length, d=diam);
        translate([-diam*5,0,0]) cylinder(h=length, d=diam);
    }
}

module circle_section(d,thickness,angle) {
    difference() {
        circle(d=d);
        circle(d=d-thickness);
        rotate([0,0,angle]) square([d,d]);
        rotate([0,0,270-angle]) square([d,d]);
        translate([0,-d]) square([d,d*2]);
    }
}
