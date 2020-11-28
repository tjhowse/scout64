18650_z = 65;
18650_r = 18.4/2;

battery_gap = 2;
big_wheel_r = 5;
little_wheel_r = 3;

wheel_offset_x = 13;
wheel_offset_y = 10;

big_wheelbase_y = 50;
big_wheelbase_x = 18650_r*4;

wheel_z = 10;

module battery() {
    cylinder(r=18650_r,h=18650_z);
}
module batteries() {
    translate([0,18650_z/2,0]){
        translate([-18650_r-battery_gap/2,0,0]) rotate([90,0,0]) battery();
        translate([18650_r+battery_gap/2,0,0]) rotate([90,0,0]) battery();
    }
}
module big_wheel() {
    cylinder(r=big_wheel_r, h=wheel_z);
}

module little_wheel() {
    cylinder(r=little_wheel_r, h=wheel_z);
}
module wheels() {
    translate([wheel_offset_x,-big_wheelbase_y/2, 0]) big_wheel();
    translate([wheel_offset_x,big_wheelbase_y/2, 0]) big_wheel();
    translate([0,-big_wheelbase_y/2+wheel_offset_y, 0]) little_wheel();
    translate([0,big_wheelbase_y/2-wheel_offset_y, 0]) little_wheel();
    // translate([wheel_offset,-big_wheelbase_y/2, 0]) little_wheel();
    // translate([0,big_wheelbase_y/2, 0]) little_wheel();
}
translate([big_wheelbase_x/2,0,0]) rotate([0,-90,0]) hull() #wheels();
translate([-big_wheelbase_x/2,0,0]) rotate([0,-90,0]) hull() #wheels();
// wheels();
batteries();