$fn=100;

linear_extrude(1) scale([0.6,0.5]) offset(r = 8) import(file="title.svg", center=true);
linear_extrude(5) scale([0.6,0.5]) offset(r = 4) import(file="title.svg", center=true);
linear_extrude(6) scale([0.6,0.5]) offset(r = 0.5) import(file="title.svg", center=true);