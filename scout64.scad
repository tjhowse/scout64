// Source: https://www.thingiverse.com/thing:29734
// Used to validate servo sizing.
use <9g_servo.scad>

18650_z = 65;
18650_r = 18.4/2;
batt_holder_x = 21;
batt_holder_y = 76;
batt_holder_z = 20;

battery_gap = 1;
big_wheel_r = 5;
little_wheel_r = 3;

wheel_offset_x = 23;
wheel_offset_y = 20;

big_wheelbase_y = 100;
big_wheelbase_x = batt_holder_x*2+battery_gap;

wheel_z = 15;
wt = 3;
ground_clearance_z = 10;

// These are first-hand numbers measured off whatever cheap 9g servos I have to hand.
// Skyartec VTS-05B
// I've found dimesioned drawings that disagree with these numbers, but not by much.
// THis is the length of the main body of the servo, excluding the flanges.
9g_servo_x = 22.85;
9g_servo_y = 11.9;
9g_servo_flange_x = (32.67-9g_servo_x)/2;
9g_servo_shaft_r = 3.7/2;


module 9g_servo_mount() {

}

module battery() {
    cylinder(r=18650_r,h=18650_z);
}
module batteries() {
    translate([0,18650_z/2,0]){
        translate([-18650_r-battery_gap/2,0,0]) rotate([90,0,0]) battery();
        translate([18650_r+battery_gap/2,0,0]) rotate([90,0,0]) battery();
    }
}
module battery_holder() {
    cube([batt_holder_x, batt_holder_y, batt_holder_z],center=true);
}

module battery_holders() {
    translate([-batt_holder_x/2-battery_gap/2,0,0]) battery_holder();
    translate([batt_holder_x/2+battery_gap/2,0,0]) battery_holder();
}

module 9g_servo() {

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

translate([big_wheelbase_x/2+wheel_z+wt,0,little_wheel_r]) rotate([0,-90,0]) hull() #wheels();
translate([-big_wheelbase_x/2-wt,0,little_wheel_r]) rotate([0,-90,0]) hull() #wheels();
translate([0,0,ground_clearance_z+batt_holder_z/2+wt]) battery_holders();
9g_motor();