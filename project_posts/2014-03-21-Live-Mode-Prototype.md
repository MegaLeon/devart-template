Here’s a peek at a feature I long thought about: the “Live Mode”. The picture field becomes a “canvas” for the user to paint on as it get mapped to the 3D Matrix in real-time.

https://www.youtube.com/watch?v=uDII9JHBSNE&feature=youtu.be

My first tackle at this system was extending the “Picture” object and add the painting functionality, but this solution proven to cause more conflicts than I expected, so I stepped back and was careful in not disrupting the original system too much, and, instead, create an “extension” of it. The “canvas” is a PGraphic object which is able to detect user’s input and get painted on, but instead of being drawn to the screen, its surface is sent to the “Picture” object, same one as the non-live mode, which proceeds in doing the analysis and 3D mapping the same way it would do with a Picasa image.

Correct in theory, this process proved to bug me a bit as the PGraphic object was sending an empty canvas to the Picture object. In Processing, PGraphic extends the PImage object I use for all image queries, and even if they are interchangeable for the methods that request a PImage, it did not seem to work so far. I even tried copying the whole Canvas pixel by pixel and pasting it on an empty PImage to pass to the picture, with no luck.

My workaround was to save the Canvas content to an actual .jpg file and have the Picture object read it back - not the cleanest and most efficient method.

I would love to bang my head more on this feature and make it nicer: right now it uses some basic painting implementation that lack smoothness and curvature, but with the deadline approaching I feel it is wiser to polish the existing features and ensure a fully working and optimized core experience rather than rushing extra capabilities.
