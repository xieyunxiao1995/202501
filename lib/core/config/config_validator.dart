import 'config_loader.dart';
import 'general_config.dart';
import 'skill_config.dart';
import 'tactic_config.dart';
import 'formation_config.dart';
import 'stage_config.dart';
import 'item_config.dart';
import 'bond_config.dart';
import 'building_config.dart';
import 'biography_config.dart';
import 'equipment_config.dart';
import 'horse_config.dart';

/// 配置校验器
///
/// 校验加载的配置数据完整性和一致性，确保：
/// - 必填字段不缺失
/// - 外键引用有效（如武将的 skillId 在 skills 配置中存在）
/// - 数值范围合法
class ConfigValidator {
  static final List<String> _errors = [];

  /// 获取校验错误列表
  static List<String> get errors => List.unmodifiable(_errors);

  /// 是否存在错误
  static bool get hasErrors => _errors.isNotEmpty;

  /// 校验所有配置
  static bool validateAll() {
    _errors.clear();

    _validateGenerals();
    _validateSkills();
    _validateTactics();
    _validateFormations();
    _validateStages();
    _validateItems();
    _validateBonds();
    _validateBuildings();
    _validateBiographies();
    _validateEquipment();
    _validateHorses();
    _validateCrossReferences();

    return _errors.isEmpty;
  }

  /// 校验武将配置
  static void _validateGenerals() {
    final generals = GeneralConfig.instance.all;
    for (final g in generals) {
      _requireField(g, 'id', 'generals');
      _requireField(g, 'name', 'generals');
      _requireField(g, 'rarity', 'generals');
      _requireField(g, 'kingdom', 'generals');
      _requireField(g, 'attack', 'generals');
      _requireField(g, 'defense', 'generals');
      _requireField(g, 'hp', 'generals');

      // 数值范围校验
      final attack = g['attack'];
      if (attack is int && attack < 0) {
        _addError('generals', '武将 ${g['id']} 的攻击力不能为负数: $attack');
      }
      final defense = g['defense'];
      if (defense is int && defense < 0) {
        _addError('generals', '武将 ${g['id']} 的防御力不能为负数: $defense');
      }
      final hp = g['hp'];
      if (hp is int && hp <= 0) {
        _addError('generals', '武将 ${g['id']} 的生命值必须大于0: $hp');
      }
    }
  }

  /// 校验技能配置
  static void _validateSkills() {
    final skills = SkillConfig.instance.all;
    for (final s in skills) {
      _requireField(s, 'id', 'skills');
      _requireField(s, 'name', 'skills');
      _requireField(s, 'type', 'skills');
      _requireField(s, 'effectValue', 'skills');

      final effectValue = s['effectValue'];
      if (effectValue is num && effectValue < 0) {
        _addError('skills', '技能 ${s['id']} 的效果值不能为负数: $effectValue');
      }
    }
  }

  /// 校验战法配置
  static void _validateTactics() {
    final tactics = TacticConfig.instance.all;
    for (final t in tactics) {
      _requireField(t, 'id', 'tactics');
      _requireField(t, 'name', 'tactics');
      _requireField(t, 'type', 'tactics');
      _requireField(t, 'quality', 'tactics');
    }
  }

  /// 校验阵法配置
  static void _validateFormations() {
    final formations = FormationConfig.instance.all;
    for (final f in formations) {
      _requireField(f, 'id', 'formations');
      _requireField(f, 'name', 'formations');
      _requireField(f, 'type', 'formations');
    }
  }

  /// 校验关卡配置
  static void _validateStages() {
    final stages = StageConfig.instance.all;
    for (final s in stages) {
      _requireField(s, 'id', 'stages');
      _requireField(s, 'name', 'stages');
      _requireField(s, 'chapterId', 'stages');
      _requireField(s, 'difficulty', 'stages');
    }
  }

  /// 校验物品配置
  static void _validateItems() {
    final items = ItemConfig.instance.all;
    for (final i in items) {
      _requireField(i, 'id', 'items');
      _requireField(i, 'name', 'items');
      _requireField(i, 'type', 'items');

      final maxStack = i['maxStack'];
      if (maxStack is int && maxStack <= 0) {
        _addError('items', '物品 ${i['id']} 的最大堆叠数必须大于0: $maxStack');
      }
    }
  }

  /// 校验羁绊配置
  static void _validateBonds() {
    final bonds = BondConfig.instance.all;
    for (final b in bonds) {
      _requireField(b, 'id', 'bonds');
      _requireField(b, 'name', 'bonds');
      _requireField(b, 'members', 'bonds');
      _requireField(b, 'type', 'bonds');

      final members = b['members'];
      if (members is List && members.length < 2) {
        _addError('bonds', '羁绊 ${b['id']} 至少需要2名成员');
      }
    }
  }

  /// 校验建筑配置
  static void _validateBuildings() {
    final buildings = BuildingConfig.instance.all;
    for (final b in buildings) {
      _requireField(b, 'id', 'buildings');
      _requireField(b, 'name', 'buildings');
      _requireField(b, 'type', 'buildings');
    }
  }

  /// 校验传记配置
  static void _validateBiographies() {
    final biographies = BiographyConfig.instance.all;
    for (final b in biographies) {
      _requireField(b, 'id', 'biographies');
      _requireField(b, 'generalId', 'biographies');
    }
  }

  /// 校验装备配置
  static void _validateEquipment() {
    final equipment = EquipmentConfig.instance.all;
    for (final e in equipment) {
      _requireField(e, 'id', 'equipment');
      _requireField(e, 'name', 'equipment');
      _requireField(e, 'slot', 'equipment');
      _requireField(e, 'quality', 'equipment');
    }
  }

  /// 校验坐骑配置
  static void _validateHorses() {
    final horses = HorseConfig.instance.all;
    for (final h in horses) {
      _requireField(h, 'id', 'horses');
      _requireField(h, 'name', 'horses');
      _requireField(h, 'quality', 'horses');
    }
  }

  /// 跨表外键引用校验
  static void _validateCrossReferences() {
    // 校验武将引用的技能ID是否存在
    for (final g in GeneralConfig.instance.all) {
      final skillIds = g['skillIds'];
      if (skillIds is List) {
        for (final skillId in skillIds) {
          if (SkillConfig.instance.getById(skillId as String) == null) {
            _addError('generals', '武将 ${g['id']} 引用了不存在的技能ID: $skillId');
          }
        }
      }
      final tacticIds = g['tacticIds'];
      if (tacticIds is List) {
        for (final tacticId in tacticIds) {
          if (TacticConfig.instance.getById(tacticId as String) == null) {
            _addError('generals', '武将 ${g['id']} 引用了不存在的战法ID: $tacticId');
          }
        }
      }
    }

    // 校验羁绊中引用的武将ID是否存在
    for (final b in BondConfig.instance.all) {
      final members = b['members'];
      if (members is List) {
        for (final memberId in members) {
          if (GeneralConfig.instance.getById(memberId as String) == null) {
            _addError('bonds', '羁绊 ${b['id']} 引用了不存在的武将ID: $memberId');
          }
        }
      }
    }

    // 校验传记中引用的武将ID是否存在
    for (final bio in BiographyConfig.instance.all) {
      final generalId = bio['generalId'];
      if (generalId is String) {
        if (GeneralConfig.instance.getById(generalId) == null) {
          _addError('biographies', '传记 ${bio['id']} 引用了不存在的武将ID: $generalId');
        }
      }
    }
  }

  /// 校验必填字段
  static void _requireField(Map<String, dynamic> map, String field, String configName) {
    if (!map.containsKey(field) || map[field] == null) {
      _addError(configName, '缺少必填字段: $field (id: ${map['id'] ?? '未知'})');
    }
  }

  /// 添加错误信息
  static void _addError(String configName, String message) {
    _errors.add('[$configName] $message');
  }
}
