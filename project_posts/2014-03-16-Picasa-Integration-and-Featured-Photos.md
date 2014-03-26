I got back to the Picasa API test I published a few post ago, and integrated that system in ArsMatrix, featuring customizable search words - here we can see a few nice results:

![searchpicasa](http://i.imgur.com/K7JcGQ4.png "searchpicasa")

The system had to change a bit to be optimized: originally a query to the Picasa public feed was made each time the user wanted to get a new image. That caused a small hangup while the APIs filled out the request with all the images (I haven’t set any maximum number of results limit to ensure a greater diversification when picking randomly from the results). I was able to fix this by loading the APIs just once, and filling an array with the URLs of the images:
```
imageUrls = new String[searchResultsFeed.getPhotoEntries().size()];

  for (int i = 0; i < searchResultsFeed.getPhotoEntries().size(); i++) {
    PhotoEntry photo = searchResultsFeed.getPhotoEntries().get(i);
    String imageUrl = photo.getMediaThumbnails().get(0).getUrl();
    String croppedUrl = imageUrl.replace("s72", "s512-c");
    imageUrls[i] = croppedUrl;
 }
```
With a string replacement, I load the URL for a specific image size - by default the 72px thumbnail is loaded, in my case I am requesting the address of a square-cropped image 512px wide. 
This way I can load them up straight away, waiting only less than a second for the image to be downloaded (Processing got a nice method called requestImage() that, differently than loadImage(), keeps the application running while the image is being loaded, so I can display a little fancy loading box.

If you have noticed that little checkbox above the picture, I implemented the possibility of limiting the search off the public feed for featured images. Doing this was easier than I thought (even if I haven’t found an official method online, I found out almost by chance): all I needed was changing the URL for my query from
```
URL("https://picasaweb.google.com/data/feed/api/all");
```
to
```
URL("https://picasaweb.google.com/data/feed/api/featured?feat=featured_all");
```

![featured](/project_images/07featured.png?raw=true "featured")

The beauty of those images is what you would expect from a featured photo!
