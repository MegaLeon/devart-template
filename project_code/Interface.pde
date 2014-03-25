import controlP5.*;
ControlP5 cp5;
int btnSize;
int margin;
int bigMargin;
int fontSize;
int currentImg = 0;

float contrast = 1, brightness, kHue, kSaturation;

Knob knobHue, knobSat, knobCont, knobBrigh;

//ControlP5
void setupControls() {
  cp5 = new ControlP5(this);

  btnSize = 48 * guiScale;
  margin = 8 * guiScale;
  bigMargin = 16 * guiScale;
  fontSize = 9 * guiScale;

  // matrix controllers
  cp5.addButton("cubes")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2 - (btnSize*2 + margin*2))
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ; 
  cp5.addButton("blobs")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2 - (btnSize*1 + margin*1))
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ;  
  cp5.addButton("bars")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2)
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ;  
  cp5.addButton("steps")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2 + (btnSize*1 + margin*1))
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ; 

  cp5.addSlider("scaleBias")
    .setBroadcast(false)
      .setLabel("Scale Bias")
        .setColorLabel(color(120))
          .setRange(0, 20)
            .setValue(1)
              .setPosition(width - btnSize*2 - margin, margin)
                .setSize(btnSize*2, btnSize/2)
                  .setBroadcast(true)
                    .getCaptionLabel().setSize(fontSize)
                      ;                   
  cp5.getController("scaleBias").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  // image manipulation controllers
  if (!isLiveMode) {

    knobCont = cp5.addKnob("knobContrast")
      .setBroadcast(false)
        .setLabel("Contrast")
          .setColorLabel(color(120))
            .setRange(0, 5)
              .setValue(1)
                .setPosition(margin, height/2 - (btnSize*2 + bigMargin*2))
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)                       
                        ;
    knobCont.getCaptionLabel().setSize(fontSize);
    knobCont.getValueLabel().setSize(fontSize);

    knobBrigh = cp5.addKnob("knobBrightness")
      .setBroadcast(false)
        .setLabel("Brightness")
          .setColorLabel(color(120))
            .setRange(-128, 128)
              .setValue(0)
                .setPosition(margin, height/2 - (btnSize + bigMargin))
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)
                        ;
    knobBrigh.getCaptionLabel().setSize(fontSize);
    knobBrigh.getValueLabel().setSize(fontSize);

    knobHue = cp5.addKnob("knobChangeHue")
      .setBroadcast(false)
        .setLabel("Hue")
          .setColorLabel(color(120))
            .setRange(0, 360)
              .setValue(0)
                .setPosition(margin, height/2)
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)
                        ;
    knobHue.getCaptionLabel().setSize(fontSize);
    knobHue.getValueLabel().setSize(fontSize);

    knobSat = cp5.addKnob("knobChangeSat")
      .setBroadcast(false)
        .setLabel("Saturation")
          .setColorLabel(color(120))
            .setRange(-50, 50)
              .setValue(0)
                .setPosition(margin, height/2 + (btnSize + bigMargin))
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)
                        ;
    knobSat.getCaptionLabel().setSize(fontSize);
    knobSat.getValueLabel().setSize(fontSize);


    cp5.addTextfield("TxtSearchWord")
      .setLabel("")
        .setPosition(width/2  - width/4 - picDisplaySize/2, height/2 - picDisplaySize/2 - margin - btnSize/2)
          .setSize(picDisplaySize/2 - margin, btnSize/2)
            .setFocus(true)
              ;
    cp5.getController("TxtSearchWord").getValueLabel().setSize(fontSize);
    cp5.getController("TxtSearchWord").getCaptionLabel().setSize(fontSize);

      cp5.addButton("btnSearchWord")
        .setBroadcast(false)
          .setLabel("Set Image Word Search")
            .setValue(0)
              .setPosition(width/2  - width/4 + margin, height/2 - picDisplaySize/2 - margin - btnSize/2)
                .setSize(picDisplaySize/2 - margin, btnSize/2)
                  .setBroadcast(true)
                    .getCaptionLabel().setSize(fontSize)
                      ;

    cp5.addSlider("mappingSpeed")
      .setBroadcast(false)
        .setLabel("Map\nspeed")
          .setColorLabel(color(120))
            .setPosition(width/2  - width/4 + picDisplaySize/2 + margin, height/2 - picDisplaySize/2)
              .setSize(btnSize/4, picDisplaySize)
                .setRange(60, 960)
                  .setValue(2048)
                    .setNumberOfTickMarks(16)
                      .setColorValueLabel(20) 
                        .setBroadcast(true)
                          .getCaptionLabel().setSize(fontSize)
                            ;

    cp5.addButton("changePic")
      .setBroadcast(false)
        .setLabel("Get new picture")
          .setValue(0)
            .setPosition(width/2  - width/4 + picDisplaySize/2 - btnSize*3, height/2 + picDisplaySize/2 + margin)
              .setSize(btnSize*3, btnSize/2)
                .setBroadcast(true)
                  .getCaptionLabel().setSize(fontSize)

                    ;

    cp5.addButton("resetKnobs")
      .setBroadcast(false)
        .setLabel("Reset")
          .setValue(0)
            .setPosition(width/2  - width/4 - picDisplaySize/2, height/2 + picDisplaySize/2 + margin)
              .setSize(btnSize, btnSize/2)
                .setBroadcast(true)
                  .getCaptionLabel().setSize(fontSize)

                    ;
  } 
  else {

    cp5.addSlider("brushSize")
      .setLabel("Brush Size")
        .setValue(3)
          .setColorLabel(color(120))
            .setPosition(width/2  - width/4 - picDisplaySize/2 + btnSize/2 + margin, height/2 + picDisplaySize/2 + margin)
              .setSize(picDisplaySize - btnSize/2 - margin, btnSize/2)
                .setRange(0, 40)
                  .getCaptionLabel().setSize(fontSize)
                    ;
    cp5.getController("brushSize").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  }
}

// controllers methods
public void cubes() {
  subdivisions = 12;
  initialize(true);
  matrix.setVisMode(0);
} 
public void blobs() { 
  subdivisions = 24;
  initialize(true);
  matrix.setVisMode(1);
} 
public void bars() { 
  subdivisions = 12;
  initialize(true);
  matrix.setVisMode(2);
} 
public void steps() { 
  subdivisions = 24;
  initialize(true);
  matrix.setVisMode(3);
}

public void knobContrast(float theValue) {
  contrast = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}

public void knobBrightness(float theValue) {
  brightness = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}

public void knobChangeHue(float theValue) {
  kHue = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}

public void knobChangeSat(float theValue) {
  kSaturation = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}


void resetKnobs() {
  knobCont.setValue(1);  
  knobBrigh.setValue(0);
  knobHue.setValue(0);
  knobSat.setValue(0);
}

public void btnSearchWord() {
  String searchWord = cp5.get(Textfield.class, "TxtSearchWord").getText();
  //println(searchWord);
  if (searchWord.length() == 0) {
    fillArrayPicasaUrls(true, "Getting Featured Images");
  } 
  else {
    fillArrayPicasaUrls(false, searchWord);
  }
  changePic();
}

public void changePic() {
  if (currentImg < 4) currentImg++; 
  else currentImg = 0;

  //picture.pickImage(currentImg);
  picture.pickPicasaImage();
  initialize(true);
  resetKnobs();
}


//************************************************************************************
//old dat-gui stuff
/*void changeVisMode() {
 if (visMode == 0) {
 visMode = 1;
 }
 else {
 visMode = 0;
 }
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
 */
