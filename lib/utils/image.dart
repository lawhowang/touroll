enum ImageType { TOUR_COVER, ACTIVITY_IMAGE, USER_ICON }

class ImageUtil {
  static String getImageUrlByIdentifier(ImageType type, String identifier) {
    String path = '';
    switch (type) {
      case ImageType.TOUR_COVER:
        path = 'tours/covers/';
        break;
      case ImageType.ACTIVITY_IMAGE:
        path = 'tours/activities/';
        break;
      case ImageType.USER_ICON:
        path = 'users/icons/';
        break;
    }
    path += '$identifier.jpg';
    return 'https://touroll.s3.amazonaws.com/$path';
  }
}
