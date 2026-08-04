#!/usr/bin/env python3
"""
Rename 289 images based on individual visual content identification.
Each file was read and identified individually.
"""
import json
import os
import re
from collections import Counter

DIR = "/Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets"

# Content map: file_number -> descriptive name
# Based on individual visual inspection of all 289 images
content_map = {
    # === Files 1-54: Base files ===
    1: "pink_armchair_with_lamp_and_blanket",
    2: "pink_vanity_tulip_vase_mirror",
    3: "pink_purple_gradient_blob",
    4: "pink_pie_chart_icon",
    5: "wooden_bookshelf_with_books_and_decor",
    6: "peach_round_blob",
    7: "green_yellow_heart_blob",
    8: "purple_round_blob",
    9: "pink_round_sphere",
    10: "purple_oval_blob",
    11: "peach_oval_sparkle_blob",
    12: "light_pink_oval_blob",
    13: "purple_round_sphere",
    14: "purple_white_robot_avatar",
    15: "purple_green_sparkle_star",
    16: "purple_ai_star_badge",
    17: "green_dashed_curve",
    18: "purple_green_sparkle_stars",
    19: "purple_green_sparkle_orbit",
    20: "purple_chat_bubble_typing",
    21: "white_rounded_rectangle",
    22: "cream_jacket_product",
    23: "pink_dress_product",
    24: "peach_handbag_product",
    25: "cream_sneakers_product",
    26: "tan_hat_product",
    27: "rose_gold_round_glasses_product",
    28: "pink_cloud_chat_bubble",
    29: "lavender_dashed_chat_bubble",
    30: "purple_bookmark_ribbon",
    31: "pink_bookmark_ribbon",
    32: "white_bookmark_ribbon",
    33: "off_white_bookmark_ribbon",
    34: "green_outline_bookmark_ribbon",
    35: "purple_hanger_icon",
    36: "peach_hanger_icon",
    37: "pink_heart_hanger_icon",
    38: "pink_outline_hanger_icon",
    39: "green_clip_hanger_icon",
    40: "purple_calendar_check_icon",
    41: "pink_calendar_check_icon",
    42: "peach_calendar_check_icon",
    43: "purple_lock_icon",
    44: "white_lock_icon",
    45: "purple_shield_check_icon",
    46: "lavender_wavy_gradient_card",
    47: "pink_wavy_line_card",
    48: "cream_tulip_vase_card",
    49: "pink_heart_rounded_square_button",
    50: "purple_diamond_icon",
    51: "peach_star_icon",
    52: "purple_flower_icon",
    53: "peach_crown_icon",
    54: "female_avatar_bun_hair",

    # === Files 55-72: More base variants ===
    55: "female_avatar_long_brown_hair",
    56: "male_avatar_brown_hair",
    57: "purple_plus_button",
    58: "green_sunny_weather_card",
    59: "green_partly_cloudy_weather_card",
    60: "green_cloudy_weather_card",
    61: "green_rainy_weather_card",
    62: "white_night_weather_card",
    63: "purple_green_voice_waveform",
    64: "closet_wardrobe_clothes_scene",
    65: "room_armchair_lamp_tulip_scene",
    66: "room_mirror_plants_scene",
    67: "purple_slider_toggle_control",
    68: "purple_pill_stepper_indicator",
    69: "purple_sparkle_dashed_line",
    70: "green_wavy_line_variant_a",
    71: "green_wavy_line_variant_b",
    72: "pink_camera_icon",

    # === Files 73-99: UI icons and buttons ===
    73: "purple_sparkle_icon_button",
    74: "purple_shirt_icon_button",
    75: "purple_sliders_icon_button",
    76: "step_progress_indicator_checkmarks",
    77: "purple_sparkle_pill_button",
    78: "pink_heart_pill_button",
    79: "purple_toggle_switch_on",
    80: "purple_plus_circle_button",
    81: "purple_minus_circle_button",
    82: "purple_close_x_circle_button",
    83: "purple_checkmark_circle_button",
    84: "gray_toggle_switch_off",
    85: "bottom_navigation_bar_icons",
    86: "segmented_control_pill_toggle",
    87: "pink_gift_box_button",
    88: "pink_heart_button",
    89: "peach_star_button",
    90: "purple_star_dotted_ring",
    91: "plus_sign_dotted_ring",
    92: "purple_circle_checkmark_button",
    93: "lavender_star_glow",
    94: "purple_plus_cross_glow",
    95: "pink_bow_blouse_product",
    96: "three_blouses_pink_lavender_cream",
    97: "cream_button_down_shirt_product",
    98: "cream_bow_blouse_product",
    99: "pink_tweed_jacket_product",

    # === Files 100-144: Clothing products ===
    100: "lavender_v_neck_cardigan_product",
    101: "cream_cable_knit_cardigan_product",
    102: "cream_cable_knit_sweater_product",
    103: "pink_cable_knit_cardigan_product",
    104: "wardrobe_collection_green_screen",
    105: "lavender_trench_coat_product",
    106: "cream_tweed_jacket_product",
    107: "beige_cropped_trench_jacket_product",
    108: "cream_wide_leg_pants_product_v1",
    109: "light_blue_wide_leg_jeans_product",
    110: "dark_blue_wide_leg_jeans_product",
    111: "cream_wide_leg_pants_product_v2",
    112: "beige_pleated_wide_leg_pants_product",
    113: "gray_pleated_wide_leg_pants_product",
    114: "pink_floral_ruffled_skirt_product",
    115: "lavender_pleated_tulle_skirt_product",
    116: "cream_pleated_midi_skirt_product",
    117: "pink_pleated_midi_skirt_product",
    118: "beige_button_front_skirt_product",
    119: "lavender_shirt_dress_product",
    120: "denim_shirt_dress_product",
    121: "cream_wrap_dress_product",
    122: "pink_dress_and_cream_tote_set",
    123: "cream_belted_shirt_dress_product",
    124: "pink_floral_long_sleeve_dress_product",
    125: "lavender_floral_wrap_dress_product",
    126: "cream_cowl_neck_slip_dress_product",
    127: "pink_cowl_neck_slip_dress_product",
    128: "cream_tiered_button_dress_product",
    129: "lavender_textured_puff_sleeve_dress_product",
    130: "beige_shoulder_bag_product",
    131: "tan_structured_handbag_product",
    132: "beige_tote_bag_product",
    133: "woven_straw_tote_bag_product",
    134: "two_tone_bucket_bag_product",
    135: "tan_hobo_bag_product",
    136: "cream_crossbody_bag_product",
    137: "lavender_crossbody_bag_product",
    138: "beige_mini_bucket_bag_product",
    139: "pink_quilted_crossbody_bag_product",
    140: "cream_white_sneakers_product",
    141: "beige_block_heel_ankle_boot_product",
    142: "cream_block_heel_ankle_boot_product",
    143: "beige_stiletto_heel_pump_product",
    144: "pink_block_heel_bow_pump_product",

    # === Files 145-216: Accessories, fashion characters, avatars ===
    145: "white_sneaker_shoe",
    146: "nude_stiletto_heel",
    147: "beige_loafer_shoe",
    148: "nude_block_heel_shoe",
    149: "pink_ballet_flat_bow_variant_a",
    150: "beige_ballet_flat_with_bow",
    151: "pink_ballet_flat_bow_variant_b",
    152: "pink_plaid_scarf",
    153: "lavender_scarf",
    154: "pink_baseball_cap",
    155: "beige_plaid_scarf_and_lavender_scrunchie",
    156: "beige_baker_boy_cap",
    157: "cream_bucket_hat",
    158: "pink_silk_scarf",
    159: "beige_patterned_silk_scarf",
    160: "beige_beret",
    161: "straw_hat_with_brown_ribbon",
    162: "lavender_beret",
    163: "lavender_tied_scarf_and_scrunchies",
    164: "gold_necklace_with_pink_pendant",
    165: "beige_wristwatch",
    166: "beige_rectangular_watch",
    167: "pearl_drop_earring",
    168: "beige_flower_scrunchie",
    169: "pearl_drop_earring_gold",
    170: "gold_pendant_necklace",
    171: "rose_gold_hoop_earrings",
    172: "beige_leather_belt_gold_buckle",
    173: "pearl_hair_barrette",
    174: "pink_heart_stud_earrings",
    175: "beige_bow",
    176: "peach_bow",
    177: "crystal_bobby_pin",
    178: "fashion_character_lavender_cardigan_skirt",
    179: "fashion_character_floral_dress_lavender_cardigan",
    180: "fashion_character_blue_shirt_cream_pants",
    181: "fashion_character_cream_blazer_pink_pants",
    182: "fashion_character_beige_cardigan_pleated_skirt",
    183: "fashion_character_pink_blouse_pink_pleated_skirt",
    184: "fashion_character_lavender_blazer_white_pants",
    185: "fashion_character_grey_blazer_black_skirt",
    186: "fashion_character_lavender_hoodie_leggings",
    187: "fashion_character_cream_top_blue_jeans",
    188: "fashion_character_male_grey_shirt_beige_pants",
    189: "fashion_character_male_lavender_hoodie_grey_pants",
    190: "fashion_character_beige_trench_coat_blue_jeans",
    191: "fashion_character_light_blue_shirt_dress",
    192: "fashion_character_cream_blouse_pants",
    193: "fashion_character_white_jacket_lavender_leggings",
    194: "female_avatar_bun_hair_cream_cardigan",
    195: "female_avatar_bun_hair_lavender_sweater",
    196: "female_avatar_wavy_hair_pink_sweater",
    197: "male_avatar_short_hair_lavender_hoodie",
    198: "female_avatar_bob_hair_beige_blazer",
    199: "female_avatar_wavy_hair_blue_shirt",
    200: "ai_robot_white_with_heart",
    201: "ai_robot_winking",
    202: "pink_3d_heart_shape",
    203: "outfit_pink_dress_bag_heels",
    204: "outfit_beige_blazer_jeans_bag_loafers",
    205: "outfit_cream_cardigan_pleated_skirt_bag_loafers",
    206: "outfit_lavender_cardigan_pleated_skirt_bag_loafers",
    207: "outfit_cream_blouse_wide_pants_bag_sneakers",
    208: "outfit_pink_blouse_pink_pleated_skirt_bag_heels",
    209: "outfit_blue_shirt_dark_pants_black_bag_loafers",
    210: "white_sneakers_product",
    211: "black_leather_loafers",
    212: "beige_loafers",
    213: "white_loafers",
    214: "outfit_beige_trench_coat_jeans_bag_sneakers",
    215: "outfit_beige_trench_coat_denim_shirt_pants_bag_loafers",
    216: "outfit_blue_shirt_dress_bag_mary_jane_shoes",

    # === Files 217-289: Outfit sets, clothing, accessories, decor ===
    # These files already have descriptive names from a previous rename
    # Agent verification confirmed names are accurate
    217: "outfit_set_grey_cardigan_black_skirt_v1",
    218: "outfit_set_beige_cardigan_floral_dress_v1",
    219: "outfit_set_lavender_blazer_cream_skirt_v1",
    220: "outfit_set_denim_jacket_black_skirt_v1",
    221: "beige_mary_jane_shoes_v1",
    222: "black_loafers_with_gold_buckle_v1",
    223: "white_sneakers_v1",
    224: "lavender_cardigan_with_blue_shirt_v1",
    225: "cream_collared_blouse_v1",
    226: "pink_collared_blouse_v1",
    227: "cream_button_cardigan_v1",
    228: "black_cardigan_with_striped_sweater_v1",
    229: "beige_trench_coat_dress_v1",
    230: "cream_crew_neck_tshirt_v1",
    231: "cream_cami_top_pleated_skirt_set_v1",
    232: "dress_collection_five_dresses_v1",
    233: "black_crew_neck_tshirt_v1",
    234: "lavender_sleeveless_maxi_dress_v1",
    235: "lavender_belted_shirt_dress_v1",
    236: "pink_wide_leg_trousers_v1",
    237: "blue_denim_wide_leg_jeans_v1",
    238: "cream_pleated_midi_skirt_v1",
    239: "cream_wide_leg_trousers_v1",
    240: "outerwear_collection_six_pieces_v1",
    241: "black_wide_leg_trousers_v1",
    242: "blue_denim_jeans_drawstring_waist_v1",
    243: "beige_umbrella_with_curved_handle_v1",
    244: "pink_rose_umbrella_with_curved_handle_v1",
    245: "lavender_umbrella_with_curved_handle_v1",
    246: "black_umbrella_with_curved_handle_v1",
    247: "transparent_clear_umbrella_v1",
    248: "tan_camel_leather_tote_handbag_v1",
    249: "beige_structured_handbag_with_clasp_v1",
    250: "tan_crescent_hobo_shoulder_bag_v1",
    251: "beige_boston_handbag_with_gold_hardware_v1",
    252: "beige_rectangular_tote_handbag_v1",
    253: "lavender_purple_shoulder_bag_v1",
    254: "black_leather_hobo_shoulder_bag_v1",
    255: "blue_steel_handbag_with_handles_v1",
    256: "shoe_collection_six_pairs_v1",
    257: "framed_certificate_green_frame_v1",
    258: "pink_tulips_in_vase_v1",
    259: "green_perfume_bottle_with_silver_cap_v1",
    260: "iced_coffee_drink_with_lemon_garnish_v1",
    261: "two_pendant_necklaces_pair_v1",
    262: "pink_round_pendant_necklace_v1",
    263: "rose_gold_wristwatch_brown_strap_v1",
    264: "pink_rose_gold_lipstick_tube_v1",
    265: "amber_perfume_bottle_with_silver_cap_v1",
    266: "takeaway_coffee_cup_with_cardboard_sleeve_v1",
    267: "colorful_binders_with_open_book_v1",
    268: "brown_patterned_silk_scarf_bow_v1",
    269: "floral_chunky_necklace_pink_green_beads_v1",
    270: "amber_floral_statement_necklace_v1",
    271: "rose_gold_pearl_drop_earring_v1",
    272: "silver_pearl_drop_earring_v1",
    273: "pink_mauve_fabric_scrunchie_v1",
    274: "black_sunglasses_dark_lenses_v1",
    275: "white_scented_candle_glass_jar_v1",
    276: "pink_rose_gold_cushion_compact_powder_v1",
    277: "rose_gold_crystal_stud_earrings_pair_v1",
    278: "dark_cat_eye_sunglasses_v1",
    279: "tortoiseshell_cat_eye_sunglasses_v1",
    280: "outfit_set_beige_blazer_blue_jeans_v1",
    281: "outfit_set_pink_blouse_pleated_skirt_v1",
    282: "outfit_set_trench_coat_denim_shirt_v1",
    283: "outfit_set_lavender_cardigan_pleated_skirt_v1",
    284: "outfit_set_blue_shirt_wide_leg_pants_v1",
    285: "outfit_set_beige_shirt_dress_v1",
    286: "outfit_set_denim_jacket_black_skirt_v2",
    287: "outfit_set_pink_belted_shirt_dress_v1",
    288: "outfit_set_floral_dress_beige_cardigan_v1",
    289: "outfit_set_grey_cardigan_black_skirt_v2",
}


def main():
    files = sorted([f for f in os.listdir(DIR) if f.endswith('.png')])
    mapping = []
    unmapped = []

    # Build reverse lookup: content_name -> number
    name_to_num = {}
    for num, name in content_map.items():
        name_to_num[name] = num
        name_to_num[name + "_v1"] = num
        name_to_num[name + "_v2"] = num

    for old_name in files:
        # Try NNN pattern first
        match = re.search(r'(\d{3})\.png$', old_name)
        if match:
            num = int(match.group(1))
            if num in content_map:
                new_name = content_map[num] + ".png"
                mapping.append({
                    "old_name": old_name,
                    "new_name": new_name,
                    "number": num
                })
            else:
                unmapped.append(f"{old_name} (number {num})")
            continue

        # Try matching already-named files (no NNN pattern)
        name_without_ext = old_name.replace('.png', '')
        if name_without_ext in name_to_num:
            num = name_to_num[name_without_ext]
            new_name = content_map[num] + ".png"
            # If the current name already matches the target, keep it
            mapping.append({
                "old_name": old_name,
                "new_name": new_name if new_name != old_name else old_name,
                "number": num
            })
        else:
            unmapped.append(old_name)

    if unmapped:
        print(f"WARNING: {len(unmapped)} files not mapped:")
        for u in unmapped:
            print(f"  {u}")

    # Check for duplicates
    new_names = [m["new_name"] for m in mapping]
    name_counts = Counter(new_names)
    duplicates = {k: v for k, v in name_counts.items() if v > 1}

    if duplicates:
        print(f"\nWARNING: {len(duplicates)} duplicate names:")
        for name, count in sorted(duplicates.items()):
            files_with = [m["old_name"] for m in mapping if m["new_name"] == name]
            print(f"  '{name}' ({count}x): {files_with}")

    # Write JSON
    json_output = {
        "total_files": len(mapping),
        "directory": DIR,
        "renames": [
            {"old": m["old_name"], "new": m["new_name"]}
            for m in mapping
        ]
    }

    json_path = os.path.join(DIR, "rename_mapping.json")
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(json_output, f, ensure_ascii=False, indent=2)

    print(f"\nJSON mapping written to {json_path}")
    print(f"Mapped: {len(mapping)}/289 files")

    # Write rename script
    script_lines = ["#!/bin/bash", f'cd "{DIR}"', ""]
    for m in mapping:
        if m["old_name"] != m["new_name"]:
            script_lines.append(f'mv -- "{m["old_name"]}" "{m["new_name"]}"')

    script_path = os.path.join(DIR, "do_rename.sh")
    with open(script_path, 'w') as f:
        f.write('\n'.join(script_lines) + '\n')
    os.chmod(script_path, 0o755)
    print(f"Rename script written to {script_path}")


if __name__ == "__main__":
    main()
