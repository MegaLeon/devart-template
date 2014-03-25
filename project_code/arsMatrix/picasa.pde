import java.io.File;
import java.net.URL;

// needs Google Data library, get it here: https://developers.google.com/gdata/articles/java_client_lib
// To install a .jar in Processing, simply drag the .jar to the sketch - it will be added to the "code" folder of the project
import com.google.gdata.client.*;
import com.google.gdata.client.photos.*;
import com.google.gdata.data.*;
import com.google.gdata.data.media.*;
import com.google.gdata.data.photos.*;

URL baseSearchUrl;
AlbumFeed searchResultsFeed;
String[] imageUrls;
int picNumber = 0;

void fillArrayPicasaUrls(boolean getFeatured, String _searchWord) {
  PicasawebService myService = new PicasawebService("leon-picasaTest-1");
  // Needs JavaMail.jar dependecy, get it here: http://www.oracle.com/technetwork/java/index-138643.html
  // Needs Guava.jar (Formerly Google Collection) dependency, get it here: https://code.google.com/p/guava-libraries/

  try {
    if (getFeatured) baseSearchUrl = new URL("https://picasaweb.google.com/data/feed/api/featured?feat=featured_all");
    else baseSearchUrl = new URL("https://picasaweb.google.com/data/feed/api/all");
  } 
  catch (Exception e) {
    println("Problem with the URL:" + e);
  }

  Query myQuery = new Query(baseSearchUrl);
  myQuery.setStringCustomParameter("kind", "photo");
  // max results to be returned
  //myQuery.setMaxResults(8);
  if (!getFeatured) myQuery.setFullTextQuery(_searchWord);

  try {
    searchResultsFeed = myService.query(myQuery, AlbumFeed.class);
  } 
  catch (Exception e) {
    println("Problem with the AlbumFeed: " + e);
  }

  imageUrls = new String[searchResultsFeed.getPhotoEntries().size()];

  for (int i = 0; i < searchResultsFeed.getPhotoEntries().size(); i++) {
    
    PhotoEntry photo = searchResultsFeed.getPhotoEntries().get(i);
    String imageUrl = photo.getMediaThumbnails().get(0).getUrl();
    String croppedUrl = imageUrl.replace("s72", "s512-c");
    imageUrls[i] = croppedUrl;
  }
}

String getRandomPicasaUrl() {
  return imageUrls[floor(random(imageUrls.length))];
}

