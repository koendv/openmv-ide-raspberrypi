$fn=36;
clearance_fit=0.4;
inch=25.4;
eps1=0.001;
eps2=2*eps1;
min_wall_thickness = 2.0;
inf=100;
w1=66.88;
h1=40.64;
w2=86.0;
d1=5.2;
r1=d1/2;
d2=3.1;
d3=d2+2*min_wall_thickness;
top_z=4.0;
bottom_z=6.2;
pcb_z=1.6;
cam_x=h1-14.5;
cam_y=79.0;
cam_d=8.0;

// --------------------------------------------------------------------------------

module small_text(txt) {
    text_h=0.4; // one layer
    translate([0,0,-text_h+eps1])
    linear_extrude(2*text_h) text(txt, size = 6, halign = "center", valign = "center");
}

/* through hole */
module hole(){
    translate([0,0,-inf/2])
    linear_extrude(inf)
    offset(clearance_fit)
    projection()
    children();
}

/* convert 3d object to 3d-printable hole */
module contour() {
    intersection() {    
        rotate([-90,0,0])
        linear_extrude(inf)
        offset(clearance_fit)
        hull()
        projection()
        rotate([90,0,0])
        children();
    
        linear_extrude(inf)
        offset(clearance_fit)
        hull()
        projection()
        children();
    }
}

// --------------------------------------------------------------------------------

module pcb() {
    difference() {
        pcb_body();
        pcb_holes();
    }
}

module pcb_body() {
    hull(){
        translate([r1, r1, 0])
        circle(d=d1);
        translate([r1, w1-r1, 0])
        circle(d=d1);
        translate([h1-r1, w1-r1, 0])
        circle(d=d1);
        translate([h1-r1, r1, 0])
        circle(d=d1);
    }
}

module pcb_holes(){
    union(){
        translate([r1, r1, 0])
        circle(d=d2);
        translate([r1, w1-r1, 0])
        circle(d=d2);
        translate([h1-r1, w1-r1, 0])
        circle(d=d2);
        translate([h1-r1, r1, 0])
        circle(d=d2);
    }
}

module base_body(){
    d=d2+2*min_wall_thickness;
    difference() {
        hull(){
            translate([r1, r1, 0])
            circle(d=d3);
            translate([r1, w2-r1, 0])
            circle(d=d3);
            translate([h1-r1, w2-r1, 0])
            circle(d=d3);
            translate([h1-r1, r1, 0])
            circle(d=d3);
        }
        pcb_holes();
    }
}

module base(h) {
    
    translate([0,0,h])
    linear_extrude(min_wall_thickness)
    base_body();
    
    linear_extrude(h)
    difference() {
        base_body();
        offset(-min_wall_thickness)
        base_body();
    }
}


// --------------------------------------------------------------------------------

module top() {
    difference() {
        base(top_z);
        led1();
        led2();
        buttons();
        lcd();
        translate([0,-min_wall_thickness,-eps1])
        usb();
        translate([0,-2*min_wall_thickness,-eps1])
        microsd();
    }
    camera_support();
}


module led1() {
    hole()
    import("led1.stl");
}

module led2() {
    hole()
    import("led2.stl");
}

module lcd() {
    translate([6.5,44,0]) {
        hole()
        cube([23.7,12.8,1]);
    }
}

module buttons() {
    hole()
    hull()
    import("buttons.stl");
}

module usb() {
    contour()
    import("usb.stl");
}

module microsd() {
    contour()
    translate([0,0,pcb_z/2])
    import("microsd.stl");
}

module camera_support() {
    translate([h1-cam_x,cam_y,0])
    translate([-cam_d/2,-cam_d/2,-pcb_z+eps1])
    cube([cam_d, cam_d, pcb_z+top_z]);
}

// --------------------------------------------------------------------------------

module bottom() {
    difference() {
        base(bottom_z+pcb_z);
        camera();
        pcb_cutout();
        
        translate([h1/2,w2/6,pcb_z+bottom_z+min_wall_thickness])
        small_text("Mini H7");
    }
}

module camera() {
    w=cam_d+clearance_fit;
    translate([cam_x,cam_y,eps1])
    cylinder(d=w, h=inf);
}

module pcb_cutout() {
    translate([0,0,-eps2])
    linear_extrude(pcb_z+eps2)
    hull(){
        translate([r1, r1, 0])
        circle(d=d3);
        translate([r1, w1-r1, 0])
        circle(d=d3);
        translate([h1-r1, w1-r1, 0])
        circle(d=d3);
        translate([h1-r1, r1, 0])
        circle(d=d3);
    }
}

// --------------------------------------------------------------------------------
module assembly() {
    color("DarkGreen", 1.0)
    3dmodel();

    translate([h1,0,pcb_z])
    rotate([0,180,0])
    bottom();

    translate([0,0,pcb_z])
    top();
}

module 3dmodel() {
    translate([0,0,pcb_z])
    import("MiniSTM32H7xx.stl");
}
// --------------------------------------------------------------------------------

module printer_ready() {
    translate([0,0,min_wall_thickness+top_z])
    rotate([180,0,0])
    top();
    
    translate([h1+10,0,min_wall_thickness+pcb_z+bottom_z])
    rotate([180,0,0])
    bottom();
}

// --------------------------------------------------------------------------------

//top();
//bottom();
//bidi();
//assembly();
//projection()
printer_ready();
