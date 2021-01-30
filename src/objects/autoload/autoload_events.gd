extends Node

signal get_skill
signal get_puzzle_item(item_name)
signal get_flash_recharge_item(item)
signal is_enemy_paralyzed
signal do_paralyze_enemy(enemy)
signal do_damage_on_enemy(enemy)

signal player_position_updated(global_position)

signal ui_show_interaction_hint(to_show)
signal ui_show_skill_use_required_hint(to_show)

signal ui_hide_skill_hint
signal ui_simple_skill_hint
signal ui_complete_skill_hint

signal ui_update_flash_gauge(value)
signal ui_flash_gauge_updated(value)
signal ui_set_flash_gauge_value(value)
signal ui_add_flash_gauge_value(value)

signal puzzle_item_photographed(item_name)
signal puzzle_unlock_item(item)

signal start_spawn_enemies
