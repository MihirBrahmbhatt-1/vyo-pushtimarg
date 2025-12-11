class CategoryListResponseModel {
  String? categoryId;
  String? categoryName;
  String? categoryDescription;
  String? categoryType;
  List<SubCategories>? subCategories;

  CategoryListResponseModel({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.categoryType,
    this.subCategories,
  });

  CategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryDescription = json['category_description'];
    categoryType = json['category_type'];
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_description'] = categoryDescription;
    data['category_type'] = categoryType;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  String? subCategoryId;
  String? subCategoryName;
  String? subCategoryDescription;
  String? subCategoryThumbnailUrl;

  SubCategories({
    this.subCategoryId,
    this.subCategoryName,
    this.subCategoryDescription,
    this.subCategoryThumbnailUrl,
  });

  SubCategories.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subcategory_id'];
    subCategoryName = json['subcategory_name'];
    subCategoryDescription = json['subcategory_description'];
    subCategoryThumbnailUrl = json['subcategory_thumbnail_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcategory_id'] = subCategoryId;
    data['subcategory_name'] = subCategoryName;
    data['subcategory_description'] = subCategoryDescription;
    data['subcategory_thumbnail_url'] = subCategoryThumbnailUrl;
    return data;
  }
}
