/// Represents a single privilege item displayed on the VIP screen.
class Privilege {
  final String iconPath;
  final String title;
  final String subtitle;

  Privilege({
    required this.iconPath,
    required this.title,
    required this.subtitle,
  });
}

/// Static list of VIP privileges.
final List<Privilege> vipPrivileges = [
  Privilege(
    iconPath: 'assets/images/vip/unlock.png',
    title: '解锁女士',
    subtitle: '每日8次',
  ),
  Privilege(
    iconPath: 'assets/images/vip/feed.png',
    title: '发布动态',
    subtitle: '每日5次',
  ),
  Privilege(
    iconPath: 'assets/images/vip/new_user.png',
    title: '优质新人',
    subtitle: '无限查看',
  ),
  Privilege(
    iconPath: 'assets/images/vip/female.png',
    title: '同城女生',
    subtitle: '优先推荐',
  ),
  Privilege(
    iconPath: 'assets/images/vip/view.png',
    title: '谁看过我',
    subtitle: '无限查看',
  ),
  Privilege(
    iconPath: 'assets/images/vip/nearby.png',
    title: '附近的人',
    subtitle: '精准出击',
  ),
  Privilege(
    iconPath: 'assets/images/vip/exposure.png',
    title: '曝光度',
    subtitle: '大幅提升',
  ),
  Privilege(
    iconPath: 'assets/images/vip/noble.png',
    title: '尊贵身份',
    subtitle: '专属标识',
  ),
  Privilege(
    iconPath: 'assets/images/vip/search.png',
    title: '查看空间',
    subtitle: '次数无限',
  ),
];
