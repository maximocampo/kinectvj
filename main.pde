import peasy.*;
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.sound.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import java.util.Collections;
import com.thomasdiewald.pixelflow.java.utils.DwColorPicker;

Amplitude amp;
AudioIn in;
 
Kinect kinect;
ControlFrame cf;
ControlP5 cp5;
PeasyCam cam;
PostFX fx;
SobelPass sobelPass;

float[] depthLookUp = new float[2048];

boolean bgReset = true;
int kthresh = 930;
int preset = 1;

boolean IR = false;

void setup() {
  cursor(CROSS);
  
  fullScreen(P3D);
  //size(1920, 1080, P3D);
  //size(800, 600, P3D);
  
  fx = new PostFX(this);
  fx.preload(BloomPass.class);
  
  cf = new ControlFrame(this,840,840,"box");
  
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  kinect.enableMirror(true);
  kinect.enableIR(IR);
   
  cam = new PeasyCam(this, 0, 0, 0, 2000);
  cam.setWheelScale(0.1);
  
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
    
  frameRate(60);
 
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);


}


void draw() {
  if (bgReset) { 
    if (soundReactive) {
      if (amp.analyze() > ampThreshold) {
        background(color(255,0,0));
      } else {
        background(bg[0], bg[1], bg[2]);
      }   
    } else {
      background(bg[0], bg[1], bg[2]); 
    }
  }

  float factor = width*0.003;
  int[] depth = kinect.getRawDepth();
  translate(-width, -height, 0);
  renderLights();

  switch(preset) {
      case(1):
        bubbleboy(depth, factor);
      break;
      case(3):
        mesh(depth, factor);
      break;
      case(4):
        points(depth, factor);
      break;
  }
  
  renderFilters();  
}

public void controlEvent(ControlEvent event) {
   switch(event.getId()) {
     case(1):
       light1.x = event.getController().getArrayValue()[0];
       light1.y = event.getController().getArrayValue()[1];   
     break;
     case(2):
       light2.x = event.getController().getArrayValue()[0];
       light2.y = event.getController().getArrayValue()[1];   
     break; 
  }
}
