Those days I put aside the task of creating more visualization modes and I focused on implementing an animated process of the image being mapped pixel by pixel, and the values being translated to the 3D matrix.

Morevoer, I started porting the project to processing.js, in order to make it able to run in browsers and presenting people with a prototype. The performance is better than I expected, although processing.js presents a few limitations; for example, the orthographic  camera doesn't seem to work, and it only supports pure Processing - that means no external libraries. 
That left me hanging a bit since I was planning to use a GUI library called controlP5 to allow user interaction, and after wandering on the lands of code for a while I found a great javascript controller library born out of a chrome experiment called dat-gui.
I spent a while getting the processing sketch, the processing.js and the dat-gui library to talk between each other since there is no really complete documentation online for this kind of three-way interaction (I am yet to figure out many things myself, I'll stick to buttons UI for now, thanks), but in the end I worked out and uploaded a first prototype! 

![prototype](http://i.imgur.com/QDlxBf6.gif "prototype")

The GUI controls the visualization modes (RGB cubes or HUE steps at the moment) and the image being processed to be chosen among 5 classical paintings; plus the number of subdivisions of the 3D matrix (of course higher values will be more taxing on your browser). Time keeps on ticking, and my project-management-spider-senses tell me it's better to come up with a plan/schedule for the upcoming weeks!

*The paintings shown are: "San Giorgio Maggiore By Twilight" By Monet.
