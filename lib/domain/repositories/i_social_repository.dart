import '../../core/network/api_result.dart';

/// 社交仓库接口
///
/// 提供好友管理相关操作，包括好友列表查询、添加好友、赠送礼物和借将。
abstract class ISocialRepository {
  /// 获取好友列表
  ///
  /// 获取当前玩家的好友列表，包括在线状态。
  Future<ApiResult<List<Map<String, dynamic>>>> getFriendList();

  /// 添加好友
  ///
  /// 向指定 [userId] 的玩家发送好友申请。
  Future<ApiResult<void>> addFriend(String userId);

  /// 赠送礼物
  ///
  /// 向指定 [friendId] 的好友赠送礼物 [giftId]。
  Future<ApiResult<void>> sendGift(String friendId, String giftId);

  /// 借用武将
  ///
  /// 向指定 [friendId] 的好友借用武将 [generalId]，用于助战。
  Future<ApiResult<Map<String, dynamic>>> borrowGeneral(
    String friendId,
    String generalId,
  );
}
