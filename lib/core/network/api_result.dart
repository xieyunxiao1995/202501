import '../error/app_exception.dart';

/// 统一 API 返回结果
///
/// 使用 sealed class 封装 API 请求的三种状态：
/// - [ApiSuccess]：请求成功，携带数据
/// - [ApiFailure]：请求失败，携带异常信息
/// - [ApiLoading]：请求加载中
///
/// 配合模式匹配使用，确保所有状态都被处理：
/// ```dart
/// final result = await httpClient.get('/user/info');
/// result.when(
///   success: (data) => print(data),
///   failure: (exception) => print(exception.message),
///   loading: () => print('加载中'),
/// );
/// ```
sealed class ApiResult<T> {
  const ApiResult();

  /// 是否请求成功
  bool get isSuccess => this is ApiSuccess<T>;

  /// 是否请求失败
  bool get isFailure => this is ApiFailure<T>;

  /// 是否加载中
  bool get isLoading => this is ApiLoading<T>;

  /// 获取成功数据，如果非成功状态则返回 null
  T? get dataOrNull => switch (this) {
        ApiSuccess<T>(:final data) => data,
        _ => null,
      };

  /// 获取失败异常，如果非失败状态则返回 null
  AppException? get exceptionOrNull => switch (this) {
        ApiFailure<T>(:final exception) => exception,
        _ => null,
      };

  /// 模式匹配回调，必须处理所有状态
  ///
  /// [success] 成功回调，接收数据 [T]
  /// [failure] 失败回调，接收 [AppException]
  /// [loading] 加载中回调
  ///
  /// 返回 [R] 类型的结果
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
    required R Function() loading,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) => success(data),
      ApiFailure<T>(:final exception) => failure(exception),
      ApiLoading<T>() => loading(),
    };
  }

  /// 可选模式匹配，仅处理指定状态，其余返回 null
  ///
  /// [success] 成功回调（可选）
  /// [failure] 失败回调（可选）
  /// [loading] 加载中回调（可选）
  R? maybeWhen<R>({
    R Function(T data)? success,
    R Function(AppException exception)? failure,
    R Function()? loading,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) when success != null => success(data),
      ApiFailure<T>(:final exception) when failure != null => failure(exception),
      ApiLoading<T>() when loading != null => loading(),
      _ => null,
    };
  }
}

/// API 请求成功结果
///
/// 携带服务端返回的数据 [data]
class ApiSuccess<T> extends ApiResult<T> {
  /// 创建成功结果
  const ApiSuccess(this.data);

  /// 服务端返回的数据
  final T data;

  @override
  String toString() => 'ApiSuccess(data: $data)';
}

/// API 请求失败结果
///
/// 携带异常信息 [exception]，可能是网络异常或服务器异常
class ApiFailure<T> extends ApiResult<T> {
  /// 创建失败结果
  const ApiFailure(this.exception);

  /// 异常信息
  final AppException exception;

  @override
  String toString() => 'ApiFailure(exception: $exception)';
}

/// API 请求加载中状态
///
/// 用于表示请求正在进行中，通常用于 UI 展示加载指示器
class ApiLoading<T> extends ApiResult<T> {
  /// 创建加载中状态
  const ApiLoading();

  @override
  String toString() => 'ApiLoading()';
}
