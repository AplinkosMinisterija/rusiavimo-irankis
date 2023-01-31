class Endpoints {
  Endpoints._();

  static const String prodBaseUrl = 'https://kaunas.think-big.lt/api/';
  static const String devBaseUrl = 'https://kaunas.think-big.lt/api/';

  static String baseUrl = 'https://kaunas.think-big.lt/api/';

  // USAGE OF BASE URL
  static String userGet = '${baseUrl}user';

  static const int connectionTimeout = 5000;
  static const int receiveTimeout = 5000;

  static const int passwordResetTimeout = 10; //in seconds!!!
}
