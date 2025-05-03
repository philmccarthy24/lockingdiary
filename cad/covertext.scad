$fn=100;

/*
linear_extrude(5) scale([0.6,0.5]) offset(r = 4) import(file="title.svg", center=true);
linear_extrude(6) scale([0.6,0.5]) offset(r = 0.5) import(file="title.svg", center=true);
*/

translate([0,50]) {
linear_extrude(5) scale([1,0.65]) offset(r = 5) import(file="title2.svg", center=true);
linear_extrude(6) scale([1,0.65]) offset(r = .4) import(file="title2.svg", center=true);
}