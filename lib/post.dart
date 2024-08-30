class Post{
  final String url = "http://127.0.0.1:8000/";
  // http://10.0.2.2:8000/
  // http://127.0.0.1:8000/
  String url2;
  String endpoint;
  Post({required this.url2, required this.endpoint});

  String getPrimaryUrl() => '$url$endpoint';
  String getFallbackUrl() => '$url2$endpoint';
}


