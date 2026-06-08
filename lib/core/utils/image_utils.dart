/// 图片工具类（骨架）
///
/// 提供图片压缩、裁剪、滤镜等方法签名，具体实现待后续完善。
class ImageUtils {
  ImageUtils._();

  /// 压缩图片
  ///
  /// [imagePath] 图片路径
  /// [maxWidth] 最大宽度
  /// [maxHeight] 最大高度
  /// [quality] 压缩质量 0~100
  /// 返回压缩后的图片字节数组
  ///
  /// TODO: 实现图片压缩逻辑，可使用 flutter_image_compress 等包
  static Future<List<int>> compressImage({
    required String imagePath,
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = 80,
  }) async {
    throw UnimplementedError('compressImage 尚未实现');
  }

  /// 裁剪图片
  ///
  /// [imagePath] 图片路径
  /// [x] 裁剪起始X坐标
  /// [y] 裁剪起始Y坐标
  /// [width] 裁剪宽度
  /// [height] 裁剪高度
  /// 返回裁剪后的图片字节数组
  ///
  /// TODO: 实现图片裁剪逻辑，可使用 image 等包
  static Future<List<int>> cropImage({
    required String imagePath,
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    throw UnimplementedError('cropImage 尚未实现');
  }

  /// 应用滤镜
  ///
  /// [imagePath] 图片路径
  /// [filterType] 滤镜类型，如 'grayscale', 'sepia', 'vintage' 等
  /// [intensity] 滤镜强度 0.0~1.0
  /// 返回滤镜处理后的图片字节数组
  ///
  /// TODO: 实现图片滤镜逻辑，可使用 image 等包
  static Future<List<int>> applyFilter({
    required String imagePath,
    required String filterType,
    double intensity = 1.0,
  }) async {
    throw UnimplementedError('applyFilter 尚未实现');
  }

  /// 生成缩略图
  ///
  /// [imagePath] 图片路径
  /// [size] 缩略图尺寸（宽高相等）
  /// 返回缩略图字节数组
  ///
  /// TODO: 实现缩略图生成逻辑
  static Future<List<int>> generateThumbnail({
    required String imagePath,
    int size = 200,
  }) async {
    throw UnimplementedError('generateThumbnail 尚未实现');
  }

  /// 获取图片尺寸信息
  ///
  /// [imagePath] 图片路径
  /// 返回 (width, height)
  ///
  /// TODO: 实现获取图片尺寸逻辑
  static Future<(int, int)> getImageSize(String imagePath) async {
    throw UnimplementedError('getImageSize 尚未实现');
  }
}
