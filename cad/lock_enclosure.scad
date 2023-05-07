difference() {
    cube([36,16,30]);
    translate([(36-24)/2,(16-12.5)/2, -1]) cube([24,12.5,28 +1]);
    translate([(36-33)/2,(16-12.5)/2, -1]) cube([33,12.5,28-16 +1]);
}

// maybe have it extend down another 5mm just on the sides the servo arm isn't? to cover the arm?