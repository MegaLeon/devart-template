Todays I started integrating the project with Google technologies. That will grant the users the possibility of picking up an image to be "arsmatrix-ified" from a vast online pool instead of being limited to an eventual gallery internal to the program.
I was initally planning to use the [Temboo](https://temboo.com/ "Temboo") libraries for the APIs call since they looked quite simple to use, but got a bit discouraged after exploring them deeper and finding out that you got limited calls and data use with a free account. Who know how many innocent megabytes and debug run will my testing take away from my PC? That said, I looked into implementing a solution myself.

The experience was less painful than I expected: even if I haven't found a specific tutorial related to Processing, the Picasa Web Albums (used internally by Google+) APIs [Starting Guides](https://developers.google.com/picasa-web/docs/2.0/developers_guide_java "Starting Guides")  are quite extensive and it's great how Processing supports pure Java, making me able to import all the needed libraries with ease.

One of my ideas for user interaction was having them typing something they'd feel or want to see, like "happiness", and having the program query that search on the public feed of Picasa, showing the user a series of related random photos and allowing the user to pick one up and start the magic.

What would happen if we were to search for "art"?

![picasaTest](/project_images/04-picasaTest.png?raw=true"picasaTest")

The results are satisfying - on top of that I'd like to have the user pick up from his collection of photos as well, making his able to see (maybe get? ;) ) its important moments translated to 3D.

The Google Photos API in Processing example is available on my Github: https://github.com/MegaLeon/devart-template/tree/master/project_code/testPicasa
Hopefully this will help people here who are trying to do similar things with Processing. I plan on writing a proper tutorial about this when my life gets a bit more peaceful since it would be a first of its kind in the world wide web.
