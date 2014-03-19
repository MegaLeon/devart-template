import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.math.noise.*;
import toxi.processing.*;

import processing.opengl.*;

float ISO_THRESHOLD = 0.05 * (matSize/240);
float NS = 0.03 * (matSize/240);
Vec3D SCALE = new Vec3D(1, 1, 1).scaleSelf(300 * (matSize/240));
float subd = 0.1 / (matSize/240);

IsoSurface surface;
TriangleMesh mesh;
VolumetricSpaceArray volume;
ToxiclibsSupport gfx;

void initMetaballs(int size, int count) {
  gfx = new ToxiclibsSupport(this);
  volume = new VolumetricSpaceArray(SCALE, int(size*subd), int(size*subd), int(size*subd));
  surface = new ArrayIsoSurface(volume);
}

void drawMetaballs(int _x, int _y, int _z, int size, int count) {
  float sizeValue;
  int subdSize = int(size*subd);

  float[] volumeData = volume.getData();
  int i, j, k;

  for (int z = 0, index = 0; z < subdSize; z++) {
    for (int y = 0; y < subdSize; y++) {
      for (int x = 0; x < subdSize; x++) {
        i = int(map(x, 0, subdSize, 0, count));
        j = int(map(y, 0, subdSize, 0, count));
        k = int(map(z, 0, subdSize, 0, count));

        sizeValue = colorMatrixRemap[i][j][k];
        volumeData[index++] = map(sizeValue, 0, size, 0, 1);
      }
    }
  }

  volume.closeSides();
  // store in IsoSurface and compute surface mesh for the given threshold value
  surface.reset();
  mesh = (TriangleMesh)surface.computeSurfaceMesh(mesh, ISO_THRESHOLD);
  float[] vertexList = mesh.getMeshAsVertexArray();

  // move to center
  pushMatrix();
  translate(_x, _y, _z);
  scale(0.75);
  fill(255);
  noStroke();

  beginShape(TRIANGLES);
  mesh.computeVertexNormals();
  colorModeRgb(true);
  // advance by 12 slots in the vertexList array, since it's structured like this:
  // (first face)[vertex1x][vertex1y][vertex1z][vertex1stride][vertex2x]...
  // http://toxiclibs.org/docs/core/toxi/geom/mesh/TriangleMesh.html#getMeshAsVertexArray(float[], int, int)
  for (int currentVert = 0; currentVert < vertexList.length ; currentVert += 12) {
    //map position of the first vertex of the the face to the red color range
    fill(map(vertexList[currentVert], -size/2, size/2, 0, 255), map(vertexList[currentVert+1], -size/2, size/2, 0, 255), map(vertexList[currentVert+2], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert], vertexList[currentVert+1], vertexList[currentVert+2] );
    
    //map position of the second vertex of the the face to the green color range
    fill(map(vertexList[currentVert+4], -size/2, size/2, 0, 255), map(vertexList[currentVert+5], -size/2, size/2, 0, 255), map(vertexList[currentVert+6], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert+4], vertexList[currentVert+5], vertexList[currentVert+6] );
    
    //map position of the third vertex of the the face to the blue color range
    fill(map(vertexList[currentVert+8], -size/2, size/2, 0, 255), map(vertexList[currentVert+9], -size/2, size/2, 0, 255), map(vertexList[currentVert+10], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert+8], vertexList[currentVert+9], vertexList[currentVert+10] );
  }
  endShape();

  //gfx.mesh(mesh, true);

  popMatrix();
}

