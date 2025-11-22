import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/enum/image_types.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';

class UnlockChatListReq {
  final String? listType;
  final int pageNum;
  final int pageSize;

  UnlockChatListReq({
    this.listType,
    required this.pageNum,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'pageNum': pageNum, 'pageSize': pageSize};
    if (listType != null) {
      data['listType'] = listType;
    }
    return data;
  }
}

class UnlockChatUserInfo {
  final int? age;
  final String? avatar;
  final String? figure;
  final int? height;
  final String? occupation;
  final int? realType;
  final int? uid;
  final String? unlockTime;
  final String? userName;
  final int? vip;

  UnlockChatUserInfo({
    this.age,
    this.avatar,
    this.figure,
    this.height,
    this.occupation,
    this.realType,
    this.uid,
    this.unlockTime,
    this.userName,
    this.vip,
  });

  factory UnlockChatUserInfo.fromJson(Map<String, dynamic> json) {
    return UnlockChatUserInfo(
      age: json['age'],
      avatar: json['avatar'],
      figure: json['figure'],
      height: json['height'],
      occupation: json['occupation'],
      realType: json['realType'],
      uid: json['uid'],
      unlockTime: json['unlockTime'],
      userName: json['userName'],
      vip: json['vip'],
    );
  }
}

class UnlockChatListData {
  final bool? hasNext;
  final List<UnlockChatUserInfo>? list;

  UnlockChatListData({this.hasNext, this.list});

  factory UnlockChatListData.fromJson(Map<String, dynamic> json) {
    return UnlockChatListData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((item) => UnlockChatUserInfo.fromJson(item))
                .toList()
          : null,
    );
  }
}

class UnlockChatListResp {
  final int code;
  final UnlockChatListData? data;
  final String? message;

  UnlockChatListResp({required this.code, this.data, this.message});

  factory UnlockChatListResp.fromJson(Map<String, dynamic> json) {
    return UnlockChatListResp(
      code: json['code'],
      data: json['data'] != null
          ? UnlockChatListData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class GetWxAccountReq {
  final int toUid;

  GetWxAccountReq({required this.toUid});

  Map<String, dynamic> toJson() => {'toUid': toUid};
}

class WxAccountData {
  // accountType 联系方式类型(QQ:QQ号,WX:微信号),可用值:QQ,WX string
  final String? accountType;
  // unlockStatus 解锁状态 0:未解锁(脱敏联系方式/按钮为点击查看) 1:已解锁(展示联系方式/按钮为复制) 2:其它问题(隐藏模块-未真人/联系方式不存在) integer(int32)
  final int? unlockStatus;
  // wxAccount 联系方式(微信号或QQ号未解锁为脱敏) string
  final String? wxAccount;

  WxAccountData({this.accountType, this.unlockStatus, this.wxAccount});

  factory WxAccountData.fromJson(Map<String, dynamic> json) => WxAccountData(
    accountType: json['accountType'] as String?,
    unlockStatus: json['unlockStatus'] as int?,
    wxAccount: json['wxAccount'] as String?,
  );
}

class GetWxAccountResp {
  final int code;
  final WxAccountData? data;
  final String? message;

  GetWxAccountResp({required this.code, this.data, this.message});

  factory GetWxAccountResp.fromJson(Map<String, dynamic> json) =>
      GetWxAccountResp(
        code: json['code'] as int? ?? -1,
        data: json['data'] != null
            ? WxAccountData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String?,
      );
}

class CheckUnlockReq {
  final String? chatType;
  final String scene;
  final int toUid;

  CheckUnlockReq({this.chatType, required this.scene, required this.toUid});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'scene': scene, 'toUid': toUid};
    if (chatType != null && chatType!.isNotEmpty) {
      data['chatType'] = chatType;
    }
    return data;
  }
}

class CheckUnlockData {
  // 联系方式类型,可用值:QQ,WX
  final String? accountType;
  // 展示邀请获得VIP按钮(0:不展示 1:展示)
  final int inviteObtainVipStatus;
  // 解锁页面code码,0解锁成功, 1解锁失败_提醒充值VIP或金币支付 2解锁失败_提醒金币支付 3解锁失败_提醒使用免费次数或开通VIP 4:提醒使用VIP次数
  final int unlockCode;
  // 解锁价格(金币)
  final int unlockCoinPrice;
  // 解锁剩余天数
  final int unlockRemainingDay;
  // 解锁剩余秒数
  final int unlockRemainingSecond;
  // 微信号
  final String? wxAccount;

  CheckUnlockData({
    this.accountType,
    required this.inviteObtainVipStatus,
    required this.unlockCode,
    required this.unlockCoinPrice,
    required this.unlockRemainingDay,
    required this.unlockRemainingSecond,
    this.wxAccount,
  });

  factory CheckUnlockData.fromJson(Map<String, dynamic> json) =>
      CheckUnlockData(
        accountType: json['accountType'] as String?,
        inviteObtainVipStatus: json['inviteObtainVipStatus'] as int? ?? 0,
        unlockCode: json['unlockCode'] as int? ?? 0,
        unlockCoinPrice: json['unlockCoinPrice'] as int? ?? 0,
        unlockRemainingDay: json['unlockRemainingDay'] as int? ?? 0,
        unlockRemainingSecond: json['unlockRemainingSecond'] as int? ?? 0,
        wxAccount: json['wxAccount'] as String?,
      );
}

class CheckUnlockResp {
  final int code;
  final CheckUnlockData? data;
  final String? message;

  CheckUnlockResp({required this.code, this.data, this.message});

  factory CheckUnlockResp.fromJson(Map<String, dynamic> json) =>
      CheckUnlockResp(
        code: json['code'] as int? ?? -1,
        data: json['data'] != null
            ? CheckUnlockData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String?,
      );
}

class RechargeUnlockReq {
  // 解锁场景,可用值:LIKE_ME_GO_CHAT,
  // MESSAGE_GET_WX,
  // MESSAGE_SEND_CHAT,
  // ME_LIKE_GO_CHAT,
  // SPACE_GET_WX,
  // SPACE_GO_CHAT,
  // SYSTEM_SEND
  final String scene;
  final int toUid;
  // 充值解锁类型 支持FREE:使用免费次数 COIN:金币支付,可用值:COIN,FREE,SYSTEM,VIP
  final String type;

  RechargeUnlockReq({
    required this.scene,
    required this.toUid,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'scene': scene,
    'toUid': toUid,
    'type': type,
  };
}

class RechargeUnlockData {
  final String? errorMsg;
  final int unlockCode;

  RechargeUnlockData({this.errorMsg, required this.unlockCode});

  factory RechargeUnlockData.fromJson(Map<String, dynamic> json) =>
      RechargeUnlockData(
        errorMsg: json['errorMsg'] as String?,
        unlockCode: json['unlockCode'] as int? ?? 0,
      );
}

class RechargeUnlockResp {
  final int code;
  final RechargeUnlockData? data;
  final String? message;

  RechargeUnlockResp({required this.code, this.data, this.message});

  factory RechargeUnlockResp.fromJson(Map<String, dynamic> json) =>
      RechargeUnlockResp(
        code: json['code'] as int? ?? -1,
        data: json['data'] != null
            ? RechargeUnlockData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String?,
      );
}

class ChatHeaderInfo {
  static const String defaultNotice =
      '亲请勿轻易通过第三方账号进行红包、转账、借款等金钱往来，以免上当受骗。微信、QQ等联系方式，谨防上当受骗。';

  const ChatHeaderInfo({
    required this.userName,
    required this.isVip,
    required this.isReal,
    required this.contactType,
    required this.noticeText,
    required this.reviewEnvDisabled,
    required this.vipRemainingDays,
    this.avatarUrl,
    this.contactAccount,
    this.contactUnlocked = false,
    this.unlockRemaining = Duration.zero,
    this.unlockStatus = 0,
    this.inviteObtainVipStatus = 0,
  });

  final String userName;
  final String? avatarUrl;
  final bool isVip;
  final bool isReal;
  final ContactType contactType;
  final String? contactAccount;
  final bool contactUnlocked;
  final Duration unlockRemaining;
  final int vipRemainingDays;
  final String noticeText;
  final bool reviewEnvDisabled;
  final int unlockStatus;
  final int inviteObtainVipStatus;

  factory ChatHeaderInfo.initial({
    required String userName,
    String? avatarUrl,
    bool isVip = false,
    bool isReal = false,
    ContactType contactType = ContactType.wechat,
  }) {
    return ChatHeaderInfo(
      userName: userName,
      avatarUrl: avatarUrl,
      isVip: isVip,
      isReal: isReal,
      contactType: contactType,
      contactAccount: null,
      contactUnlocked: false,
      unlockRemaining: Duration.zero,
      vipRemainingDays: 0,
      noticeText: defaultNotice,
      reviewEnvDisabled: false,
      unlockStatus: 0,
      inviteObtainVipStatus: 0,
    );
  }

  factory ChatHeaderInfo.fromApi(
    ChatHeadInfoData data, {
    required String fallbackName,
    String? fallbackAvatar,
    ChatHeaderInfo? previous,
  }) {
    final name = (data.userName?.isNotEmpty ?? false)
        ? data.userName!
        : previous?.userName ?? fallbackName;
    final avatar = (data.avatar?.isNotEmpty ?? false)
        ? data.avatar
        : previous?.avatarUrl ?? fallbackAvatar;
    final contactType = data.accountType?.toUpperCase() == 'QQ'
        ? ContactType.qq
        : ContactType.wechat;
    final seconds = data.unlockRemainingSecond;
    return ChatHeaderInfo(
      userName: name,
      avatarUrl: avatar,
      isVip: data.vip == 1,
      isReal: data.realType == 1,
      contactType: contactType,
      contactAccount: data.wxAccount,
      contactUnlocked: data.unlockStatus == 1,
      unlockRemaining: Duration(seconds: seconds < 0 ? 0 : seconds),
      vipRemainingDays: previous?.vipRemainingDays ?? 0,
      noticeText: previous?.noticeText ?? defaultNotice,
      reviewEnvDisabled: previous?.reviewEnvDisabled ?? false,
      unlockStatus: data.unlockStatus,
      inviteObtainVipStatus: previous?.inviteObtainVipStatus ?? 0,
    );
  }

  ChatHeaderInfo copyWith({bool? reviewEnvDisabled}) {
    return ChatHeaderInfo(
      userName: userName,
      avatarUrl: avatarUrl,
      isVip: isVip,
      isReal: isReal,
      contactType: contactType,
      contactAccount: contactAccount,
      contactUnlocked: contactUnlocked,
      unlockRemaining: unlockRemaining,
      vipRemainingDays: vipRemainingDays,
      noticeText: noticeText,
      reviewEnvDisabled: reviewEnvDisabled ?? this.reviewEnvDisabled,
      unlockStatus: unlockStatus,
      inviteObtainVipStatus: inviteObtainVipStatus,
    );
  }

  bool shouldShowContactBox(int currentUserSex) {
    if (reviewEnvDisabled) return false;
    if (unlockStatus == 2) return false;
    if (contactAccount == null || contactAccount!.isEmpty) return false;
    if (currentUserSex != 1) return false;
    return true;
  }

  String get displayContact =>
      contactUnlocked ? (contactAccount ?? maskedContact) : maskedContact;

  String get maskedContact {
    if (contactAccount == null || contactAccount!.isEmpty) {
      return contactType == ContactType.wechat ? 'wx******' : 'qq******';
    }
    final value = contactAccount!;
    if (value.length <= 3) {
      return '${value.substring(0, 1)}****';
    }
    return '${value.substring(0, 2)}****';
  }

  String get unlockRemainingLabel {
    final hours = unlockRemaining.inHours;
    final minutes = unlockRemaining.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')} 小时 ${minutes.toString().padLeft(2, '0')} 分钟';
  }
}

enum ContactType { wechat, qq }

extension ContactTypeX on ContactType {
  String get displayName => this == ContactType.wechat ? '微信' : 'QQ';
  IconData get icon =>
      this == ContactType.wechat ? Icons.wechat : Icons.chat_bubble_outline;
}

class CurrentUserInfo {
  const CurrentUserInfo({
    required this.sex,
    required this.isRealCertified,
    this.avatarUrl,
  });

  final int sex;
  final bool isRealCertified;
  final String? avatarUrl;
}

enum MessageContentType { text, image, location, audio, custom, system }

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.isMine,
    required this.raw,
    this.text,
    this.imageUrl,
    this.avatarUrl,
    this.locationArea,
    this.locationAddress,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.audioDuration,
  });

  final String id;
  final MessageContentType type;
  final DateTime timestamp;
  final bool isMine;
  final V2TimMessage raw;
  final String? text;
  final String? imageUrl;
  final String? avatarUrl;
  final String? locationArea;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final Duration? audioDuration;

  static ChatMessage? fromV2(
    V2TimMessage message, {
    String? currentUserId,
    String? fallbackAvatar,
  }) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      (message.timestamp ?? 0) * 1000,
    );
    final msgId = message.msgID ?? message.id ?? UniqueKey().toString();
    final isMine = message.isSelf ?? (message.sender == currentUserId);
    final avatar = message.faceUrl ?? fallbackAvatar;

    switch (message.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return ChatMessage(
          id: msgId,
          type: MessageContentType.text,
          timestamp: timestamp,
          isMine: isMine,
          text: message.textElem?.text ?? '',
          avatarUrl: avatar,
          raw: message,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        final elem = message.imageElem;
        String? url;
        if (elem != null &&
            elem.imageList != null &&
            elem.imageList!.isNotEmpty) {
          final List<V2TimImage?> images = elem.imageList!;
          V2TimImage? candidate = images.firstWhere(
            (item) => item?.type == V2TIM_IMAGE_TYPE.V2TIM_IMAGE_TYPE_LARGE,
            orElse: () => null,
          );
          candidate ??= images.firstWhere(
            (item) => item?.type == V2TIM_IMAGE_TYPE.V2TIM_IMAGE_TYPE_ORIGIN,
            orElse: () => null,
          );
          candidate ??= images.first;
          url = candidate?.url ?? candidate?.localUrl;
        }
        return ChatMessage(
          id: msgId,
          type: MessageContentType.image,
          timestamp: timestamp,
          isMine: isMine,
          imageUrl: url,
          avatarUrl: avatar,
          raw: message,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        final elem = message.locationElem;
        String? area;
        String? address;
        String? mapUrl;
        if (elem != null) {
          final desc = elem.desc;
          if (desc != null && desc.isNotEmpty) {
            try {
              final map = jsonDecode(desc) as Map<String, dynamic>;
              area = map['area'] as String? ?? desc;
              address = map['address'] as String? ?? '';
              mapUrl = map['mapUrl'] as String?;
            } catch (_) {
              area = desc;
              address = '';
            }
          }
        }
        return ChatMessage(
          id: msgId,
          type: MessageContentType.location,
          timestamp: timestamp,
          isMine: isMine,
          avatarUrl: avatar,
          locationArea: area ?? '',
          locationAddress: address ?? '',
          latitude: elem?.latitude,
          longitude: elem?.longitude,
          mapUrl: mapUrl,
          raw: message,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        final duration = message.soundElem?.duration ?? 0;
        return ChatMessage(
          id: msgId,
          type: MessageContentType.audio,
          timestamp: timestamp,
          isMine: isMine,
          avatarUrl: avatar,
          audioDuration: Duration(seconds: duration),
          raw: message,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        final text = _parseCustomText(message.customElem?.data);
        final isSystem = message.sender == 'system';
        return ChatMessage(
          id: msgId,
          type: isSystem
              ? MessageContentType.system
              : MessageContentType.custom,
          timestamp: timestamp,
          isMine: isMine,
          avatarUrl: avatar,
          text: text,
          raw: message,
        );
      default:
        return ChatMessage(
          id: msgId,
          type: MessageContentType.text,
          timestamp: timestamp,
          isMine: isMine,
          text: '[暂不支持的消息类型]',
          avatarUrl: avatar,
          raw: message,
        );
    }
  }

  static String _parseCustomText(String? data) {
    if (data == null || data.isEmpty) return '';
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        if (decoded['content'] is Map) {
          final content = decoded['content'] as Map;
          if (content['text'] is String) {
            return content['text'] as String;
          }
        }
        if (decoded['text'] is String) {
          return decoded['text'] as String;
        }
      }
    } catch (_) {
      // ignore parse error
    }
    return data;
  }
}

// --- Location Search Models ---

class NearbySearchReq {
  final double latitude;
  final double longitude;
  final int pageNum;
  final int pageSize;

  NearbySearchReq({
    required this.latitude,
    required this.longitude,
    required this.pageNum,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'pageNum': pageNum,
    'pageSize': pageSize,
  };
}

class PlaceSearchReq {
  final String name;
  final double latitude;
  final double longitude;
  final int pageNum;
  final int pageSize;

  PlaceSearchReq({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pageNum,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'pageNum': pageNum,
    'pageSize': pageSize,
  };
}

class NearbyAddress {
  final String name;
  final String address;
  final String distance;
  final double? latitude;
  final double? longitude;

  NearbyAddress({
    required this.name,
    required this.address,
    required this.distance,
    this.latitude,
    this.longitude,
  });

  factory NearbyAddress.fromJson(Map<String, dynamic> json) {
    return NearbyAddress(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

class NearbySearchData {
  final bool hasNext;
  final List<NearbyAddress> list;

  NearbySearchData({required this.hasNext, required this.list});

  factory NearbySearchData.fromJson(Map<String, dynamic> json) {
    return NearbySearchData(
      hasNext: json['hasNext'] as bool? ?? false,
      list:
          (json['list'] as List<dynamic>?)
              ?.map((e) => NearbyAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class NearbySearchResp {
  final int code;
  final NearbySearchData? data;
  final String? message;

  NearbySearchResp({required this.code, this.data, this.message});

  factory NearbySearchResp.fromJson(Map<String, dynamic> json) {
    return NearbySearchResp(
      code: json['code'] as int? ?? -1,
      data: json['data'] != null
          ? NearbySearchData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }
}
