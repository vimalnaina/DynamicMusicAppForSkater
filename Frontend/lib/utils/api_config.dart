class ApiConfig {
  static const String ip = "10.20.176.170";
  static const String portNumber = "44433";
  //static const String baseUrl = "$ip:$portNumber";
  // https://ec2-54-198-242-251.compute-1.amazonaws.com:44433/user/login
  static const String baseUrl =
      "localhost:44433";
  static String login = "user/login";
  static String save = "user/save";
  static String songList = "music/list";
  static String uploadSong = "music/uploadSong";
  static String getSong = "music/";
  static String getImage = "image/";
  static String getSongsByLevel = "list/";
  static String createSongList = "list/add";
  static String getAllSongLists = "list";
  static String getSongListById = "kafka/";
  static String getSlots = "reservation/available/";
  static String getBoardSlots = "reservation/today/";
  static String bookAppointment = "reservation/addAppointment";
  static String getAllSkaters = "user/allSkaters";
  static String createRaceList = "competition/addRaceList";
  static String getAllRaceLists = "competition/getRaceList";
  static String userAnnouncement = "announcement/user/";
  static String songAnnouncement = "announcement/song/";

  static String addRecommend = "recommend/add/";
  static String retriveHistory = "recommend/favourite";
}
