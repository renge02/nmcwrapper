class FileUrlResponse {
  String? fileUrl;
  List<FileStoreItem>? fileStoreIds;

  FileUrlResponse({
    this.fileUrl,
    this.fileStoreIds,
  });

  factory FileUrlResponse.fromJson(Map<String, dynamic> json) {
    String? url;

    // Get the dynamic URL key (UUID key)
    json.forEach((key, value) {
      if (key != 'fileStoreIds' && value is String) {
        url = value;
      }
    });

    return FileUrlResponse(
      fileUrl: url,
      fileStoreIds: (json['fileStoreIds'] as List?)
          ?.map((e) => FileStoreItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileUrl': fileUrl,
      'fileStoreIds': fileStoreIds?.map((e) => e.toJson()).toList(),
    };
  }
}

class FileStoreItem {
  String? id;
  String? url;

  FileStoreItem({
    this.id,
    this.url,
  });

  factory FileStoreItem.fromJson(Map<String, dynamic> json) {
    return FileStoreItem(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}