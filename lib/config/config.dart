class AppConfig {
  // static const String baseURL = "http://81.71.64.65:9099/api";
  // 华哥正式环境
  static const String baseURL = "https://api.xuanyuanwenhua.cn/api-py";
  // 测试环境
  // static const String baseURL = "https://dev.realmeet.lejutech.cn/api-py";
}

class AppDocs {
  static const String docUrl = 'https://www.xuanyuanwenhua.cn/';

  static const Map<String, Map<String, String>> docData = {
    'WEB_URL_PROTOCAL': {'tit': "隐私政策", 'url': "policy2/yszc/yszc.html"},
    'WEB_URL_USERAGREE': {'tit': "用户协议", 'url': "policy2/fwxy/fwxy.html"},
    'WEB_URL_PAY': {'tit': "充值协议", 'url': "policy2/czxy/czxy.html"},
    'WEB_URL_VIP': {'tit': "会员充值协议", 'url': "policy2/hyxy/hyxy.html"},
    'WEB_URL_INVITE': {'tit': "邀请注意事项", 'url': "policy/yqzysx.html"},
    'WEB_URL_PERSONAL': {'tit': "个人信息使用", 'url': "policy/dsfsj.html"},
    'WEB_URL_THREAD': {'tit': "第三方共享", 'url': "policy/dsfgx.html"},
    'WEB_URL_AWARD': {'tit': "邀请有奖", 'url': "h5/policy2/yq/index.html"},
    'SERVER': {'tit': "在线客服", 'url': "h5/policy2/yq/index.html"},
  };
}
