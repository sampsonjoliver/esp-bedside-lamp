// =============================================
// Lamp Model
// =============================================

// --- Overall dimensions ---
lamp_width   = 230;  // total length along long axis (mm)
lamp_depth   = 120;  // total depth along short axis (mm)
total_height = 160;  // assembled height base + diffuser (mm)

// --- Base ---
base_height           = 40;   // total base height (mm)
base_floor_thickness  = 15;   // base floor thickness — must clear ESP32 pocket + clip groove (mm)
base_wall_thickness   = 5;    // base side wall thickness (mm) — must exceed diffuser_wall_thickness; difference is tenon width
base_diffuser_overlap               = 10;   // how far the diffuser clamps down over the base top (mm)

// --- Diffuser ---
diffuser_wall_thickness     = 3;  // side wall thickness (mm)
diffuser_top_thickness      = 3;  // top wall thickness — thicker to give 1.5mm under disc pocket (mm)
diffuser_top_roundover      = 2;  // roundover radius on top outer edge (mm)

// --- Copper disc (top button) ---
disc_r             = 40;   // disc radius (mm)
disc_thickness     = 2;    // disc thickness (mm)
disc_pocket_depth  = 1.5;  // pocket depth — disc proud by (disc_thickness - disc_pocket_depth) = 0.5mm

// --- LED form ---
led_gap             = 32;  // inset from outer lamp wall to LED form outer surface (mm)
led_height          = 100; // LED form height (mm)
led_wall_thickness  = 2;   // LED form wall thickness (mm)
led_clip_depth      = 2;   // depth of locating rim that seats into base floor groove (mm)
led_hole_r          = 6;   // radius of cable pass-through holes in LED form walls (mm)

// --- Wire routing ---
wire_r = 2;  // radius of vertical wire channel through diffuser top and LED form (mm)

// --- EC11 rotary encoder (front face) ---
enc_shaft_r     = 3.25; // shaft hole radius — 6.5mm diameter for EC11 (mm)
enc_body_width  = 14;   // encoder body cavity width (mm)
enc_body_depth  = 15;   // encoder body cavity depth into base wall (mm)
enc_body_height = 14;   // encoder body cavity height (mm)

// --- USB-C decoy board (rear face) ---
usbc_port_width   = 9.5;  // USB-C port opening width (mm)
usbc_port_height  = 3.5;  // USB-C port opening height (mm)
usbc_board_width  = 10.7; // board width (mm)
usbc_board_length = 28;   // board length — extends inward from rear wall (mm)
usbc_board_height = 7;    // board + component height — measure and update (mm)

// --- ESP32 board (lies flat on base floor, inside LED form) ---
// Active: ESP32-S3 Pico — swap values below to use WROOM-32D for prototyping
// ESP32-WROOM-32D DevKit: esp_length=52, esp_width=28, esp_component_height=10
esp_length           = 51;   // board length (mm) — verify against datasheet
esp_width            = 21;   // board width  (mm) — verify against datasheet
esp_component_height = 4;    // tallest component height (mm) — verify against datasheet
esp_pocket_depth     = 1.5;  // locating pocket depth in base floor (mm)

// --- Render quality ---
$fn = 64;

// --- Derived (do not edit) ---
diff_h  = total_height - base_height + base_diffuser_overlap;  // diffuser height including base_diffuser_overlap
pill_r  = lamp_depth / 2;                        // end-cap radius of pill shape
pill_cx = (lamp_width - lamp_depth) / 2;         // centre-to-centre half-spacing of pill cylinders
led_r   = pill_r - led_gap;                      // LED form outer radius
enc_z   = (base_height - base_diffuser_overlap) / 2;           // z-centre of encoder shaft and USB-C port


// =============================================
// Helper: pill-shaped hull of two cylinders
// =============================================
module pill(r, h) {
    hull() {
        translate([-pill_cx, 0, 0]) cylinder(r=r, h=h);
        translate([ pill_cx, 0, 0]) cylinder(r=r, h=h);
    }
}


// =============================================
// Diffuser outer shell with top edge roundover.
// Uses minkowski + sphere for true roundover on all
// top edges, then clips the bottom flat.
// =============================================
module diffuser_outer() {
    r = diffuser_top_roundover;
    intersection() {
        minkowski() {
            pill(pill_r - r, diff_h - r);
            sphere(r=r);
        }
        // Clip bottom flat — minkowski expands downward by r
        translate([0, 0, diff_h / 2])
            cube([lamp_width * 2, lamp_depth * 2, diff_h], center=true);
    }
}

// =============================================
// Diffuser
// Hollow pill, open bottom, 3mm side walls, 3mm top.
// Top outer edge has a 2mm roundover.
// Top has a pocket for the copper disc and a
// vertical wire channel routing to the ESP32.
// Print orientation: upright on open bottom.
// =============================================
module diffuser() {
    color("white", 0.85)
    difference() {
        diffuser_outer();

        // Inner cavity — open at bottom, diffuser_top_thickness top wall
        translate([0, 0, -0.1])
            pill(pill_r - diffuser_wall_thickness, diff_h - diffuser_top_thickness + 0.1);

        // Copper disc pocket — disc protrudes 0.5mm proud of top surface
        translate([0, 0, diff_h - disc_pocket_depth])
            cylinder(r=disc_r, h=disc_pocket_depth + 0.1);

        // Vertical wire channel — runs full height, exits through pocket floor
        translate([0, 0, -0.1])
            cylinder(r=wire_r, h=diff_h + 0.2);
    }
}


// =============================================
// Base
// Hollow pill, 3mm side walls, 15mm floor, open top.
// Top base_diffuser_overlap region is stepped to form friction-fit
// tenon for the diffuser.
// Front face (-Y): EC11 encoder shaft hole + body cavity.
// Rear face  (+Y): USB-C port hole + board pocket.
// Floor: ESP32 locating pocket + LED form clip groove.
// Print orientation: upright on floor.
// =============================================
module base() {
    color("#5C3A1E")
    difference() {
        pill(pill_r, base_height);

        // Inner cavity — base_floor_thickness floor, open top
        translate([0, 0, base_floor_thickness])
            pill(pill_r - base_wall_thickness, base_height - base_floor_thickness + 0.1);

        // Friction-fit tenon — steps top base_diffuser_overlap region inward by diffuser_wall_thickness
        // so diffuser inner wall seats flush over the top of the base
        translate([0, 0, base_height - base_diffuser_overlap])
            difference() {
                pill(pill_r + 0.1, base_diffuser_overlap + 0.1);
                pill(pill_r - diffuser_wall_thickness, base_diffuser_overlap + 0.2);
            }

        // EC11 encoder shaft hole — front face (-Y), centred horizontally and vertically
        translate([0, -(pill_r + 0.1), enc_z])
            rotate([-90, 0, 0])
                cylinder(r=enc_shaft_r, h=base_wall_thickness + 5);

        // EC11 encoder body cavity — pocket behind front wall, aligned with shaft
        translate([-enc_body_width/2, -(pill_r - base_wall_thickness), enc_z - enc_body_height/2])
            cube([enc_body_width, enc_body_depth, enc_body_height]);

        // LED form clip groove — ring channel in base floor that the LED form rim seats into
        translate([0, 0, base_floor_thickness - led_clip_depth])
            difference() {
                pill(led_r + 0.1, led_clip_depth + 0.1);
                pill(led_r - led_wall_thickness, led_clip_depth + 0.1);
            }

        // ESP32 locating pocket — centred in base floor, board lies flat
        translate([-esp_length/2, -esp_width/2, base_floor_thickness - esp_pocket_depth])
            cube([esp_length, esp_width, esp_pocket_depth + 0.1]);

        // USB-C port opening — rear face (+Y), aligned vertically with encoder
        translate([-usbc_port_width/2, pill_r - base_wall_thickness - 0.1, enc_z - usbc_port_height/2])
            cube([usbc_port_width, base_wall_thickness + 0.2, usbc_port_height]);

        // USB-C decoy board pocket — friction fit, board drops in from open top
        // connector end at rear wall, board extends inward
        translate([-usbc_board_width/2, pill_r - base_wall_thickness - usbc_board_length, enc_z - usbc_board_height/2])
            cube([usbc_board_width, usbc_board_length, usbc_board_height]);
    }
}


// =============================================
// LED Form
// Hollow pill tube — LED strip winds around outside.
// Bottom rim seats into clip groove in base floor.
// Front and rear walls have cable pass-through holes
// for routing encoder and USB-C wires to the ESP32.
// Print orientation: upright.
// =============================================
module led_form() {
    color("white", 0.4)
    difference() {
        // Outer shell — rim extends led_clip_depth below z=0 to seat in groove
        translate([0, 0, -led_clip_depth])
            pill(led_r, led_height + led_clip_depth);

        // Inner cavity — open bottom, closed top (led_wall_thickness top wall)
        translate([0, 0, -(led_clip_depth + 0.1)])
            pill(led_r - led_wall_thickness, led_height - led_wall_thickness + 0.1);

        // Vertical wire channel — aligns with diffuser wire channel above
        translate([0, 0, -(led_clip_depth + 0.1)])
            cylinder(r=wire_r, h=led_height + led_clip_depth + 0.2);

        // Cable hole — front wall, toward encoder
        translate([0, -(led_r + 0.1), led_hole_r + led_clip_depth])
            rotate([-90, 0, 0])
                cylinder(r=led_hole_r, h=led_wall_thickness + 0.2);

        // Cable hole — rear wall, toward USB-C board
        translate([0, led_r - led_wall_thickness - 0.1, led_hole_r + led_clip_depth])
            rotate([-90, 0, 0])
                cylinder(r=led_hole_r, h=led_wall_thickness + 0.2);
    }
}


// =============================================
// Copper Disc
// Sits in diffuser top pocket, protrudes 0.5mm proud.
// Capacitive touch sensor wired to ESP32 via wire channel.
// =============================================
module copper_disc() {
    color([0.72, 0.45, 0.20])
    cylinder(r=disc_r, h=disc_thickness);
}


// =============================================
// Assembly
// Comment out individual modules to isolate
// parts for slicing / printing.
// =============================================

// Base (z = 0 to base_height)
// base();

// Diffuser — bottom rim seats over base tenon at z = base_height - base_diffuser_overlap
//translate([0, 0, base_height - base_diffuser_overlap])
//    diffuser();

// LED form — rim drops into base floor groove; body rises from z = base_floor_thickness
//translate([0, 0, base_floor_thickness])
    led_form();

// Copper disc — recessed into diffuser top pocket, protrudes 0.5mm above lamp top
//translate([0, 0, (base_height - base_diffuser_overlap) + diff_h - disc_pocket_depth])
//    copper_disc();
