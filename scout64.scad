// Source: https://www.thingiverse.com/thing:29734
// Used to validate servo sizing.
use <9g_servo.scad>

zff = 0.001;
18650_z = 65;
18650_r = 18.4/2;
batt_holder_x = 21;
batt_holder_y = 76;
batt_holder_z = 20;

battery_gap = 1;
big_wheel_r = 5;
little_wheel_r = big_wheel_r;

upper_wheel_height = 23;
tread_angle = 45;
wheel_offset_y = upper_wheel_height/tan(tread_angle);

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
// This dimesion was taken from a drawing
9g_servo_shaft_offset = 10.6-9g_servo_flange_x;
9g_servo_extra = 0.5;
9g_servo_flange_hole_r = 1;

module 9g_servo_cutout() {
    #translate([-9g_servo_shaft_offset,0,0]) {
        cube([9g_servo_x+9g_servo_extra,9g_servo_y+9g_servo_extra,100],center=true);
        translate([9g_servo_x/2+9g_servo_flange_x/2,0,-50]) cylinder(r=9g_servo_flange_hole_r, h=100, $fn=20);
        translate([-9g_servo_x/2-9g_servo_flange_x/2,0,-50]) cylinder(r=9g_servo_flange_hole_r, h=100, $fn=20);
    }
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
    translate([upper_wheel_height,-big_wheelbase_y/2, 0]) big_wheel();
    translate([upper_wheel_height,big_wheelbase_y/2, 0]) big_wheel();
    translate([0,-big_wheelbase_y/2+wheel_offset_y, 0]) little_wheel();
    translate([0,big_wheelbase_y/2-wheel_offset_y, 0]) little_wheel();
    // translate([wheel_offset,-big_wheelbase_y/2, 0]) little_wheel();
    // translate([0,big_wheelbase_y/2, 0]) little_wheel();
}

track_bump_r = 2;

// Calculating the length of the tread required:
// Top: big_wheelbase_y
// Bottom: big_wheelbase_y-wheel_offset_y*2
// Front and rear sloped parts: 2*sqrt(pow(big_wheelbase_y,2)+pow(big_wheelbase_x,2))
track_length_ish = big_wheelbase_y+(big_wheelbase_y-wheel_offset_y*2)+2*sqrt(pow(wheel_offset_y,2)+pow(upper_wheel_height,2));
// Divide the length of the track into N bump segments. Dodgy hack to make it even.
track_bump_n = round(track_length_ish/(track_bump_r*2)) + round(track_length_ish/(track_bump_r*2))%2;
// Calculate the final real track length by multiplying the number of bumps by the bump size
track_length = track_bump_n * track_bump_r * 2;
track_width = 10;
echo(track_bump_n);
echo(track_length);

module track() {

    rad = track_length/PI/2;

    union() {
        difference () {
            cylinder(r=rad, h=track_width);
            for (i = [0:(360/track_bump_n)*2:360]) {
                rotate([0,0,i]) translate([rad,0,-zff]) cylinder(r=track_bump_r, h=track_width+2*zff, $fn=30);
            }
        }
        for (i = [(360/track_bump_n):(360/track_bump_n)*2:360]) {
            rotate([0,0,i]) translate([rad,0,0]) cylinder(r=track_bump_r, h=track_width, $fn=30);
        }
    }

}

track();
// big_wheel();
// hull() #wheels();

// translate([big_wheelbase_x/2+wheel_z+wt,0,little_wheel_r]) rotate([0,-90,0]) hull() #wheels();
// translate([-big_wheelbase_x/2-wt,0,little_wheel_r]) rotate([0,-90,0]) hull() #wheels();
// translate([0,0,ground_clearance_z+batt_holder_z/2+wt]) battery_holders();
// translate([-9g_servo_shaft_offset,0,0]) 9g_motor();
// difference() {
//     translate([-9g_servo_shaft_offset,0,0]) cube([9g_servo_x+9g_servo_flange_x+2*wt, 9g_servo_y+2*wt, wt],center=true);
//     9g_servo_cutout();

// }