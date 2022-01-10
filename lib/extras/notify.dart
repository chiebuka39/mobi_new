enum NotificationType {
  USER_CONNECTED,
  RIDE_INVITE,
  RIDE_REQUEST,
  RIDE_ACCEPTED,
  RANDOM
}

class Notify {
  static NotificationType getTypeFromInt(String type){
    NotificationType notification;
    switch(type){
      case '1':
        notification = NotificationType.USER_CONNECTED;
        break;
      case '2':
        notification = NotificationType.RIDE_INVITE;
        break;
      case '3':
        notification = NotificationType.RIDE_ACCEPTED;
        break;
      case '4':
        notification = NotificationType.RIDE_REQUEST;
        break;
      case '5':
        notification = NotificationType.RANDOM;
        break;
    }
    return notification;
  }

  static String getIntFromType(NotificationType type1){
    String type;
    switch(type1){
      case NotificationType.USER_CONNECTED:
        type = '1';
        break;
      case NotificationType.RIDE_INVITE:
        type = '2';
        break;
      case NotificationType.RIDE_ACCEPTED:
        type = '3';
        break;
      case NotificationType.RIDE_REQUEST:
        type = '4';
        break;
      case NotificationType.RANDOM:
        type = '5';
        break;
    }
    return type;
  }


}