# ArsMatrix

```
because 2 dimensions are not enough.
```

## Authors
- Leonardo Cavaletti - https://github.com/MegaLeon

## Description
ArsMatrix is an Processing Project aimed at becoming an interactive installation where people can explore and witness the properties of colors across multiple dimensions. ArsMatrix takes a 2-dimensional images and maps its color-information to a 3-dimensional Matrix, generating a 3D structure unique to each each image.

The animated process and will show the 3D piece growing as the image is being scanned. The user will be able to change color balances and 3D visualization styles and see their changes in real time, hopefully coming to an higher understanding of color in what I hope to be a mesmerizing experience.

Images are picked randomly from the Google Picasa’s public feeds, eaither from the featured images album or using a word chosen by the user as a search bias. During the last development stage I implemented an experimental "live mode" uin which people will be able to paint a sketch on a blank canvas and see their images coming to life as 3D structures in real time, encouraging them to unleash their hidden artist.

In the perfect image of the interactive installation I have in my mind, people are able to send the resulting 3D figure to a 3D printer and get a tiny, multi-colored miniature as a memento of the whole experience.

## Link to Application
- [ArsMatrix Processing Source Code |](https://github.com/MegaLeon/devart-template/tree/master/project_code "ArsMatrix Processing Source Code")
The Source Code is available on Girhub - as the rules do not allow me to upload binaries files. The libraries are included within the repo, so if you have Processing and Java installed it should run fine.

## Link to Prototypes
- [JS Applet Prototype |](http://arsmatrix.neocities.org/jstest.html "Prototype 01 | JS Applet")
An early javascript test as the visualization techniques were coming into form. Use the GUI on the right to change settings and drag the slider to switch between different paintings, click "Start Mapping" to restart the process.

## Libraries Used
- [Processing](http://processing.org/ "Processing")
- [Toxiclibs](http://toxiclibs.org/ "Toxiclibs")
- [ControlP5](http://www.sojamo.de/libraries/controlP5/ "ControlP5")
- [Picasa APIs](https://developers.google.com/picasa-web/ "Picasa APIs")
- [objexporter](http://n-e-r-v-o-u-s.com/tools/obj/ "NervousSystem's objexporter")
- [Processing.js](http://processingjs.org/ "Processing.js")
- [dat-gui](https://code.google.com/p/dat-gui/ "dat-gui")

## Image & Videos
![visualizations](/project_images/06vis.png?raw=true "visualizations")

![featured](/project_images/07featured.png "featured")

### Application Overview
A video of my playing with the app, switching visualization modes and their options, getting pictures off the Picasa's public feed and not, and toying with the color correction knobs.
http://youtu.be/YaA3dAJz6sI

### Picasa API Integration
Showing how different search terms lead to different images being dowloaded thanks to the Goggle Picasa APIs
http://youtu.be/de8ctoCSosI

### Android Mode
ArsMatrix running on a Nexus 7, mapping images saved locally
https://www.youtube.com/watch?v=vvfsJg6Hax4

### Live Mode
Experimental feature in which the user's drawings are translated to the 3D Matrix in real time
https://www.youtube.com/watch?v=uDII9JHBSNE&feature=youtu.be
