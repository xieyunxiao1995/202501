import 'package:flutter/material.dart';

class InvateRuleScreen extends StatelessWidget {
  const InvateRuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('邀请规则'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleSection(
              title: '1. 邀请流程',
              rules: [
                '邀请人在 APP 内获取专属邀请链接或',
                '通过社交平台(如微信、QQ等)、短信等渠道分享给潜在新用户。',
                '新用户点击邀请链接或在注册页面输入邀请码，完成注册流程，并在 APP 内进行一定操作(如真人认证、充值等)。',
              ],
            ),
            _RuleSection(
              title: '2. 新用户判定标准',
              rules: [
                '从未在本 APP 进行过注册的用户，使用新的手机号码、新设备(基于设备识别码判定)、新的第三方账号(如微信、微博等首次登录本 APP)完成注册流程，且注册信息真实有效，视为新用户。',
              ],
            ),
            _RuleSection(
              title: '3. 虚假邀请行为界定',
              rules: [
                '使用机器刷量、批量注册虚假账号等方式进行邀请，通过作弊手段制造大量不存在的或非真实活跃的新用户注册。',
                '利用技术手段绕过 APP 正常邀请流程，直接篡改数据以达成邀请记录。',
                '使用机器刷量、批量注册虚假账号等方式进行邀请，通过作弊手段制造大量不存在的或非真实活跃的新用户注册。',
              ],
            ),
            _RuleSection(
              title: '4. 违规违法活动关联',
              rules: [
                '若邀请行为涉及诱导新用户参与传销、非法集资、诈骗等违法犯罪活动，包括但不限于以本 APP 邀请奖励为幌子，吸引新用户加入其他非法组织或参与非法项目。',
                '通过邀请传播色情、暴力、恐怖主义、反动等违法有害信息，或者利用 APP 进行非法交易(如买卖违禁物品、盗版软件等)，并以邀请新用户为手段扩大违法活动范围。',
              ],
            ),
            _RuleSection(
              title: '5. 处罚措施',
              rules: [
                '对于存在虚假邀请行为的用户，一经发现，立即取消其当次及以往因虚假邀请所获得的全部奖励，并追回已发放的现金奖励。同时，根据情节严重程度，对涉事账号采取警告、限制部分功能使用(如限制提现限制邀请功能等)、封禁账号等处罚措施。',
                '若用户的邀请行为涉及违法犯罪活动，本 APP 将立即停止与其相关的一切服务，并将相关线索及证据提交给公安机关等执法部门，依法追究其法律责任。因用户违规违法邀请行为给本 APP 或其他用户造成损失的，涉事用户需承担相应的赔偿责任。',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  final String title;
  final List<String> rules;

  const _RuleSection({required this.title, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rule,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
