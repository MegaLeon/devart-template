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

void setup() {
  size(1000,500);
  PicasawebService myService = new PicasawebService("leon-picasaTest-1");
  // Needs JavaMail.jar dependecy, get it here: http://www.oracle.com/technetwork/java/index-138643.html
  // Needs Guava.jar (Formerly Google Collection) dependency, get it here: https://code.google.com/p/guava-libraries/

  try {
    baseSearchUrl = new URL("https://picasaweb.google.com/data/feed/api/all");
  } 
  catch (Exception e) {
    println("Problem with the URL:" + e);
  }

  Query myQuery = new Query(baseSearchUrl);
  myQuery.setStringCustomParameter("kind", "photo");
  // max results to be returned
  myQuery.setMaxResults(8);
  // search parameters: in my case, "art"
  myQuery.setFullTextQuery("art");

  try {
    searchResultsFeed = myService.query(myQuery, AlbumFeed.class);
  } 
  catch (Exception e) {
    println("Problem with the AlbumFeed: " + e);
  }

  for (PhotoEntry photo : searchResultsFeed.getPhotoEntries()) {
    // get the data out of the pictures
    println("Title: " + photo.getTitle().getPlainText());   
    println("URL: " + photo.getMediaThumbnails().get(0).getUrl());
    
    //the "s72" number in the url is the size of the thumbnail. Change it to get the image size.
    //The uncropped generated sizes are: 94, 110, 128, 200, 220, 288, 320, 400, 512, 576, 640, 720, 800, 912, 1024, 1152, 1280, 1440, 1600
    //replace "s72" with, for example, "s512" or "w990-h600-c" to force size, width, height or add cropping.
    //in my case, I want a 220*220 cropped image.
    String imageUrl = photo.getMediaThumbnails().get(0).getUrl();
    String croppedUrl = imageUrl.replace("s72", "s220-c");
    // cropped image URL
    println(croppedUrl);

    // Create a new PImage
    PImage pic = loadImage(croppedUrl);   
    // Sort in on a grid with some modulus expressions
    image(pic, 32 + picNumber % 4 * 240, 10 + (picNumber/ 4) % 2 * 240);
    picNumber ++;
  }
}

