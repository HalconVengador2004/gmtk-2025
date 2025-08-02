shader_type canvas_item;

uniform vec4 progress_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 mid_energy_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform vec4 low_energy_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 background_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform float threshold : hint_range(0.0, 1.0) = 0.2;
uniform float fade_smoothness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 color = background_color;
    vec4 current_progress_color;

    float y = 1.0 - UV.y;
    float yellow_pos = threshold + 0.1;

    if (y < threshold) {
        current_progress_color = low_energy_color;
    } else if (y < yellow_pos) {
        float gradient_factor = smoothstep(threshold, yellow_pos, y);
        current_progress_color = mix(low_energy_color, mid_energy_color, gradient_factor);
    } else {
        float gradient_factor = smoothstep(yellow_pos, 1.0, y);
        current_progress_color = mix(mid_energy_color, progress_color, gradient_factor);
    }

    if (UV.y > (1.0 - progress)) {
        color = current_progress_color;
    }

    COLOR = color;
}
