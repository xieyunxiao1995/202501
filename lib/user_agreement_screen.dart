import 'package:flutter/material.dart';

/// 用户协议页面
class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('用户协议'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00F0FF),
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildAgreementContent(),
      ),
    );
  }

  Widget _buildAgreementContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '用户服务协议',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '更新日期：2025年4月1日',
          style: const TextStyle(fontSize: 12, color: Color(0xFF667788)),
        ),
        const SizedBox(height: 20),
        _buildSection(
          '一、协议的接受与修改',
          '1.1 用户在下载、安装或使用《星轨防线》（以下简称"本游戏"）前，应仔细阅读本协议。一旦开始使用本游戏，即表示用户已充分理解并同意接受本协议的全部内容。\n\n'
              '1.2 本游戏保留随时修改本协议的权利。修改后的协议一经公布即生效，用户继续使用本游戏视为接受修改后的协议。',
        ),
        _buildSection(
          '二、服务内容',
          '2.1 本游戏向用户提供免费的休闲娱乐服务，包含但不限于：关卡闯关、成就系统、任务系统、角色升级、卡片收集等功能。\n\n'
              '2.2 用户理解并同意，本游戏可能包含虚拟货币（星尘）等虚拟道具，这些虚拟道具仅可在游戏内使用，不具备真实货币价值。',
        ),
        _buildSection(
          '三、用户行为规范',
          '3.1 用户在使用本游戏时应遵守中华人民共和国相关法律法规，不得利用本游戏从事任何违法违规行为。\n\n'
              '3.2 用户不得对本游戏进行反向工程、反编译、反汇编或其他类似操作。\n\n'
              '3.3 用户不得利用游戏漏洞或外挂程序获取不正当利益，不得进行任何破坏游戏公平性的行为。',
        ),
        _buildSection(
          '四、账号管理',
          '4.1 用户应妥善保管自己的游戏账号信息，因用户个人原因导致的账号被盗、信息泄露等损失由用户自行承担。\n\n'
              '4.2 本游戏有权在发现用户账号存在违规行为时，对账号进行封禁或其他处理。',
        ),
        _buildSection(
          '五、知识产权',
          '5.1 本游戏的所有内容，包括但不限于文字、图像、音频、视频、代码等均受知识产权法保护。\n\n'
              '5.2 未经本游戏权利人书面许可，任何人不得擅自复制、传播、修改本游戏的任何部分。',
        ),
        _buildSection(
          '六、免责声明',
          '6.1 本游戏按"现状"提供，不对其适用性、安全性作任何明示或暗示的保证。\n\n'
              '6.2 因网络故障、系统维护等原因导致的服务中断，本游戏不承担相关责任。\n\n'
              '6.3 用户因使用本游戏而产生的任何直接或间接损失，本游戏不承担赔偿责任。',
        ),
        _buildSection(
          '七、争议解决',
          '本协议的解释、效力及纠纷的解决，适用中华人民共和国法律。若双方发生纠纷，应首先通过友好协商解决；协商不成的，任何一方均可向本游戏运营方所在地人民法院提起诉讼。',
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            '— 协议结束 —',
            style: const TextStyle(fontSize: 13, color: Color(0xFF445566)),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00F0FF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFAABBCC),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
