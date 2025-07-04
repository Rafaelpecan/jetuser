class SearchplaceModel{

  String? placeId;
  String? mainText;
  String? secondaryText;

  SearchplaceModel({
    this.placeId,
    this.mainText,
    this.secondaryText
  });

  
  SearchplaceModel.fromMap(Map<String, dynamic> map) :
    placeId = map['place_id'] as String,
    mainText = map["structured_formatting"]['main_text'] as String,
    secondaryText = map["structured_formatting"]['secondary_text'] as String;
}