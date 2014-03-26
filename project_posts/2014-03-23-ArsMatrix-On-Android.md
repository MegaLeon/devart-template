Since the interactive installation is meant to work with touch screen, it was only natural for me to try and find a way to see how it would feel like. Processing features an “Android Mode” port, which surprisingly works very well, and makes totally sense since Android application runs on Java as well. 

https://www.youtube.com/watch?v=vvfsJg6Hax4

Of course, being a porting of a PC application, comes with some limitations: for example, keyboard events do not go through, so it’s impossible to change the word to search by; invocations for mouse buttons do not work (I can see why); the use of lighting in OpenGL mode causes some color problems (thus reverting back to a constant-fill-and-stroke look); the color-correction methods cause the application to crash and the Google APIs throws an error about the MediaContent object, so at the moment it is working with local images.

Right now the resolution of the application is hard-coded for my Nexus 7 screen, although every element of the application as well with the interface scales up automatically since it set it up in a modular way, which makes it easy to quickly change its size for different devices. Still, nice to see it working on a mobile touch screen, with a performance that exceeded my expectations! Although I think I will spare my loyal Galaxy S1 from the experience :)
