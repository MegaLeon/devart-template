I added some controllers that will grant the user some basic control over the color manipulation of the image. The nice part of this is how those changes are reflected in real time in the 3D matrix and will cause the 3D structure to shift differently based on the parameter being changed and the visualization type.

![colorc](/project_images/08colorcorr.gif "colorc")

It was fascinating to see how the 3D shapes move according to the changes. In a RGB colorspace, changing the hue seems to spin the matrix around an imaginary diagonal axis. It all makes sense when you think of color from a mathematical point of view.

The Color Correction process is quite straightforward: when the image is loaded, the original one is stored into a PImgae which is left untouched, while the mapping process is based on a copy which can be color corrected. Every time the user changes a knob, the pixels of the original PImage are read, modified according to the new values, and pasted on the PImage which will be analysed. Then, the mapping method is called with a flag that tells it to map the whole image at once ( instead of doing it piece by piece to show an animated process, like when the image is first loaded).

In order to make the process faster, color picking is implemented using the bit shifting technique (as outlined [here](http://www.processing.org/reference/rightshift.html "here")).
