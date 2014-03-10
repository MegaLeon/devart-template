During thw weeken I used Toxiclibs to implement a [metaballs](http://en.wikipedia.org/wiki/Metaballs "metaballs")-like visualization style. Toxiclibs offers many convenient functions related to 3D volumes - in my case I changed the size of a voxel in space based on the frequency of the color to which that voxel is mapped and computing the surface mesh given a threshold value.

![animmeta](http://i.imgur.com/MXQxCn4.gif "animmeta")

Implementing vertex coloring and getting nice gradients on the mesh was a bit more of a challenge: again, Toxiclibs, offers some fast functions to draw the resulting mesh, but in my case I wanted to edit the individual vertex colors based on their position in space.

I ended up computing the surface mesh, but instead of drawing it I extracted the list of its vertices using the “getMeshAsVertexArray” function. This function stores the vertices with this order:
```
Creates an array of unravelled vertex coordinates for all faces. This method can be used to translate the internal mesh data structure into a format suitable for OpenGL Vertex Buffer Objects (by choosing stride=4). The order of the array will be as follows:
Face 1:
Vertex #1
x
y
z
[optional empty indices to match stride setting]
Vertex #2
x
y
z
[optional empty indices to match stride setting]
Vertex #3
x
y
z
[optional empty indices to match stride setting]
Face 2:
Vertex #1
...etc.
```

This way, I was able to started drawing a new 3D shape by going through the previous list of vertices and coloring each one by mapping its coordinates to whatever color model I wanted to use:

```
beginShape(TRIANGLES);
  mesh.computeVertexNormals();
  colorMode(RGB, 255);

for (int currentVert = 0; currentVert < vertexList.length ; currentVert += 12) {
    //map position of the first vertex of the the face to the red color range
    fill(map(vertexList[currentVert], -size/2, size/2, 0, 255), map(vertexList[currentVert+1], -size/2, size/2, 0, 255), map(vertexList[currentVert+2], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert], vertexList[currentVert+1], vertexList[currentVert+2] );
    
    //map position of the second vertex of the the face to the green color range
    fill(map(vertexList[currentVert+4], -size/2, size/2, 0, 255), map(vertexList[currentVert+5], -size/2, size/2, 0, 255), map(vertexList[currentVert+6], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert+4], vertexList[currentVert+5], vertexList[currentVert+6] );
    
    //map position of the third vertex of the the face to the blue color range
    fill(map(vertexList[currentVert+8], -size/2, size/2, 0, 255), map(vertexList[currentVert+9], -size/2, size/2, 0, 255), map(vertexList[currentVert+10], -size/2, size/2, 0, 255));

  }
  endShape();
```

![metaballs]/project_images/05metaballs.png "metaballs")

I am happy to have "hacked" this effect as the final result looks great and it was my first time playing around with Toxiclibs, even tho I knew of their good reputation in the Processins environment. They are a truly powerful library and I am looking forward to use it more in future projects.
