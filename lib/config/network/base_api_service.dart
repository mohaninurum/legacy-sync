import 'package:file_picker/file_picker.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';

abstract class BaseApiServices {
  ResultFuture getGetApiResponse(String serviceUrl);
  ResultFuture getPostApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture patchApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPutApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getDeleteApiResponse(
    String serviceUrl,
    Map<String, dynamic> body,
  );
  ResultFuture getPostDownloadZip(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPostUploadMultiPartApiResponse(
    String url,
    Map<String, String> dic,
    dynamic fileBytes,
    String fileName,
    String key,
    String reqMehod,
  );
  ResultFuture getPostMultiFileUpload(
    String url,
    Map<String, String> dic,
    List<PlatformFile> fileList,
    String key,
    String reqMehod,
  );
  ResultFuture multiFileUpload(
    String url,
    Map<String, String> dic,
    List<PlatformFile> fileList,
    String key,
    String reqMehod,
    Function(double progress)? onUploadProgress,
  );
  ResultFuture deleteResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture pathResponse(String serviceUrl, Map<String, dynamic> body);
}
