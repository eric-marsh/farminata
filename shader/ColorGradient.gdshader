shader_type canvas_item;

// Color intensities
uniform float red_value = 0.0;
uniform float green_value = 0.0;
uniform float blue_value = 0.0;

uniform float half_color_mult = 0.75;

// Custom colors (in normalized RGB)
uniform vec3 red_color = vec3(0.9804, 0.3294, 0.3411);    // #fa5457
//uniform vec3 green_color = vec3(0.3725, 0.6470, 0.3529);  // #5fa55a
uniform vec3 green_color = vec3(0.9647058823529412, 0.8352941176470589, 0.12156862745098039);   // #01b4bc
uniform vec3 blue_color = vec3(0.0039, 0.7058, 0.7372);   // #01b4bc

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (tex_color.a < 0.01) {
        discard;
    }

    bool red_active = red_value > 0.0;
    bool green_active = green_value > 0.0;
    bool blue_active = blue_value > 0.0;

    int active_colors = int(red_active) + int(green_active) + int(blue_active);

    vec3 color = vec3(1.0); // Default white

    if (active_colors == 1) {
        if (red_active) {
            color = mix(vec3(1.0), red_color, red_value * half_color_mult);
        } else if (green_active) {
            color = mix(vec3(1.0), green_color, green_value * half_color_mult);
        } else if (blue_active) {
            color = mix(vec3(1.0), blue_color, blue_value * half_color_mult);
        }
    } else if (active_colors == 2) {
        float section = UV.x;

        if (red_active && green_active) {
            color = mix(vec3(1.0), section < 0.5 ? red_color : green_color, (section < 0.5 ? red_value : green_value) * half_color_mult);
        } else if (red_active && blue_active) {
            color = mix(vec3(1.0), section < 0.5 ? red_color : blue_color, (section < 0.5 ? red_value : blue_value) * half_color_mult);
        } else if (green_active && blue_active) {
            color = mix(vec3(1.0), section < 0.5 ? green_color : blue_color, (section < 0.5 ? green_value : blue_value) * half_color_mult);
        }
    } else if (active_colors == 3) {
        float section = UV.x;
        if (section < 1.0 / 3.0) {
            color = mix(vec3(1.0), red_color, red_value * half_color_mult);
        } else if (section < 2.0 / 3.0) {
            color = mix(vec3(1.0), green_color, green_value * half_color_mult);
        } else {
            color = mix(vec3(1.0), blue_color, blue_value * half_color_mult);
        }
    }

    COLOR = vec4(color, 1.0);
}