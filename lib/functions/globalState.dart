class GlobalState{
  static const SERVER = 'http://192.168.1.38:3000/';
  static const CHECKCONNECTION = '${SERVER}checkConnection';
  static const RESTAURANTS = '${SERVER}restaurants';
  static const HOTELS = '${SERVER}hotels';
  static const CAFES = '${SERVER}cafes';
  static const LOGIN = '${SERVER}login';
  static const SIGNUP = '${SERVER}signup';
  static const RESERVATION = '${SERVER}reservation';
  static const RESTAURANTS_IMAGES = '${SERVER}restaurantsImages';
  static const HOTELS_IMAGES = '${SERVER}hotelsImages';
  static const CAFES_IMAGES = '${SERVER}cafesImages';
  static const DETECT_PLACES_CHANGES = '${SERVER}detectPlacesChanges';

  final Map<String, dynamic> _data = <String, dynamic>{};
  static GlobalState instance = new GlobalState._();

  GlobalState._();

  set(String key, dynamic value) => _data[key] = value;
  get(String key) => _data[key];
}