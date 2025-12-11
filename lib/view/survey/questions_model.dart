import 'package:flutter/material.dart';

// Question types including 'number' and 'textarea'
enum QuestionType {
  yesNo,
  multiSelect,
  singleSelect,
  text,
  textarea,
  number,
  singleImage,
  multiImage,
  dateTime,
  date,
  time,
  unknown, // Added for exhaustive switch handling
}

// 🎯 NEW: Extension to convert an integer (from API) to QuestionType Enum
extension QuestionTypeExtension on QuestionType {
  /// Converts an integer value (API code) to the corresponding QuestionType enum value.
  /// 
  /// IMPORTANT: This conversion assumes the API integer values are mapped 
  /// to the ordinal position of the enum members (0 = yesNo, 1 = multiSelect, etc.).
  /// If your API uses arbitrary codes, update this to a 'switch' block.
  static QuestionType fromInt(int typeValue) {
    // Check if the value is within the valid range (excluding 'unknown')
    if (typeValue >= 0 && typeValue < QuestionType.time.index + 1) {
      return QuestionType.values[typeValue];
    }
    
    // Fallback for any unexpected or unmapped integer value
    return QuestionType.unknown;
  }
}

// -----------------------------------------------------------------------------
// Options Model
// -----------------------------------------------------------------------------

class QuestionOption {
  final String id;
  final String label;
  final String? optionValue; // Mapped from JSON
  final int sequence;
  final bool isRequired; 
  final String? extra;
  
  // Custom properties for UI flexibility (optional)
  final IconData? icon; 
  final String? imageUrl; 
  final String? assetPath; 

  QuestionOption({
    required this.id,
    required this.label,
    this.optionValue,
    required this.sequence,
    required this.isRequired,
    this.extra,
    this.icon,
    this.imageUrl,
    this.assetPath,
  });

  // 🎯 NEW: Factory constructor to map the API Options model to the app's QuestionOption
  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    final String optionKey = json['option_value'] as String? ?? '';
    // Simple way to generate a readable label (e.g., "option_key" -> "Option Key")
    final label = optionKey.replaceAll('_', ' ');

    return QuestionOption(
        id: json['id'] as String,
        label: label,
        optionValue: optionKey,
        sequence: json['sequence'] as int? ?? 0,
        isRequired: json['is_required'] as bool? ?? false,
        imageUrl: json['image_url'] as String?,
        extra: json['extra'] as String?,
    );
  }
}

// -----------------------------------------------------------------------------
// Question Model (Internal App Representation)
// -----------------------------------------------------------------------------

class Question {
  final String id;
  final String title; // This is the localization key (questionKey from API)
  final String? subtitle;
  final QuestionType type;
  final bool isRequired; // 🎯 NEW: Added from API model
  final List<QuestionOption> options;
  final String? placeholder; // extra from API

  Question({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    required this.isRequired,
    this.options = const [],
    this.placeholder,
  });

  // 🎯 NEW: Factory constructor to convert from the API response model
  // Note: You must ensure SurveyQuestionListResponseModel is available in the scope 
  // where this is used (e.g., in SurveyController)
  static Question fromApiModel(dynamic apiModel) {
    // Assuming apiModel is SurveyQuestionListResponseModel for clean separation, 
    // but often it's passed as a Map<String, dynamic>. 
    // Since SurveyController passes the full object, we'll use a dynamic type 
    // to avoid circular dependency here and cast later.
    final Map<String, dynamic> json = apiModel.toJson(); // Convert API Model to Map
    
    final int typeInt = json['type'] as int? ?? QuestionType.unknown.index;
    
    // Convert API options to local QuestionOption list
    final List<QuestionOption> options = (json['Options'] as List<dynamic>?)
        ?.map((opt) => QuestionOption.fromJson(opt as Map<String, dynamic>))
        .toList() ?? [];

    return Question(
        id: json['id'] as String? ?? '',
        title: json['question_value'] as String? ?? '', 
        type: QuestionTypeExtension.fromInt(typeInt),
        isRequired: json['is_required'] as bool? ?? false,
        options: options,
        placeholder: json['extra'] as String?,
        // Subtitle is not available in the current API model, so it remains null
    );
  }
}