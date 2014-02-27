After cleaning and tidying up the code, I pushed forward some more visualizations: this time I am mapping the color spectrum values along the vertical axis, creating a "panel" which is as wide as that spectrum is more frequent in the image:

![gioconda](/project_images/03gioconda.png?raw=true "gioconda")

The first thing I noticed was that things didn't really appear like they should be! In the "Gioconda" picture, for example, I was expecting way more "greens" - I actually spent some time trying to debug the code as I was thinking I was ding something wrong... this visualization only maps the spectrum (Hue) of the color, ignoring saturation and brightness - really makes you think how much depth there is behind this pictures and the concept of "color" in general".

![stars](/project_images/03sunday.png?raw=true "stars")

The more I play around the more ideas I get! I'd like to implement saturation and brightness alongside the Hue in my next test to see if things fall better in their places. Plus, looking at those images, I thought it would be fun to arrange the "tiles" based on their size in order to build a little "pyramid" unique to the image... I've got even more ideas about future implementations of the tool, but I'll save that for a full-fledged post!

*The paintings shown are: "Gioconda" by Leonardo daVinci, "A Sunday Afternoon on the Island of La Grande Jatte" by Georges Seurat.
