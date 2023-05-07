$fn=100;

linear_extrude(1) scale([0.5,0.5,0.5]) offset(r = 8) import(file="title.svg", center=true);
linear_extrude(5) scale([0.5,0.5,0.5]) offset(r = 3) import(file="title.svg", center=true);
linear_extrude(6) scale([0.5,0.5,0.5]) import(file="title.svg", center=true);