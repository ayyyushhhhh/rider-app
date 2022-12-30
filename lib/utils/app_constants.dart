class AppConstants {
  static const String mapBoxAccessToken =
      'sk.eyJ1IjoiYXl5eXVzaGhoaGgiLCJhIjoiY2xjNmUwdzR2MGxseDNucnh2YWljZTA5eSJ9.l9fFYn7Lqe2fHS7h-wPCnw';

  static String mapURl({required String coordinates}) {
    return "https://api.mapbox.com/directions/v5/mapbox/driving/$coordinates?geometries=polyline&access_token=$mapBoxAccessToken";
  }
}
