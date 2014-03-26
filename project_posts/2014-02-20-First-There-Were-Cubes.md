During those days I coded some basic experiments on the concept I intend to explore: the image is read, and its color values are mapped to a 3D space., In this case, each axis represents a color (R,G,B), but I want to explore more combinations to see if I come across some interesting results.

![gioconda](/project_images/02gioconda.png?raw=true "gioconda")
![stars](/project_images/02stars.png?raw=true "stars")

As you can see, the more frequent a color in the image is the bigger the cube that represents it in 3D space. I was already bashing my head on this initial concept since drawing 255x255x255 cubes was going to be too much, and when I reduced the subdivisions I had to take that in consideration when mapping and calculate the average around a cube's area. Here you can see the same image with increasing subdivisions.

![starsC](/project_images/03starsComparison.png?raw=true "starsC")

Now it's time to leave cubes behind and try something new.
*The paintings shown are: "Gioconda" by Leonardo daVinci, "Starry Night" by Vincent van Gogh.
