//old dat-gui stuff
void changeVisMode() {
  if (visMode == 0) {visMode = 1;}
  else {visMode = 0;}
}

void setCurrentImg(int theimg) {
  currentImg = theimg;
}

void setSubdivisions(int subds) {
  if (visMode == 0) {
    count = subds / 2;
  } 
  else {
    count = subds * 2;
  }
}

