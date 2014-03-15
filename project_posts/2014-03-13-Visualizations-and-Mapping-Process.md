As I am pinning down the visualization styles that I want to feature, I am going to talk a bit more about the “color mapping” process, since it’s the building block behind the whole project. The whole process happens in two steps: the “analysis”, and the “drawing”.

![visualizations](/project_images/06vis.png?raw=true "visualizations")

First of all, we set the subdivisions of the 3D matrix, also known as how many “slots” we could fill. Then, during the “analysis” process, we initialize two 3-dimensional arrays, one for the red, green and blue values and the other for the hue, saturation, and colors, which are as big as the subdivisions of the matrix (for a matrix with 12 subdivisions, the array will have 12 “slots” for each value. 

We start reading the image pixels are read one by one: when a pixel is mapped, its color values are re-arranged inside those arrays. Red, green, and blue values go from 0 to 255, so, for example, a pixel has a red intensity of 120 and we have a array with 12 slots, the slot number 6 will have its value increased.

With this process, the slots corresponding to the colors which are more frequent in the image will have higher values.

![rgbcube](/project_images/06rgb.png?raw=true "rgbcube")

During the “draw” process, 3D shapes are drawn in the 3D space according to the colorspace: let’s image red, green and blue as the sides of a cube, like in the image above. If, by following a side of the cube we are going through the “red” direction, 3D shapes in that area will be bigger if the image has lots of reddish colors.

Thiis process can be bent to other color modes, such as hue, saturation and value. There were lots of different visualization ideas popping in my mind.

If we alternate “analyse” and “draw” processes, we will have an animated sequence as the 3D shapes grow while the image is being mapped more and more. Or, if we “analyse” the whole image and then do the “drawing”, the 3D matrix will be displayed instantly. It’s a fast process that allows real-time manipulation and changes. More to come.
