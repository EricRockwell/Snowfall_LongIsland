FloatTable data;
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int rowCount;
int columnCount;
int currentColumn = 0;
int currentRow = 0;


int yearInterval = 10;
int volumeInterval = 3;
float volumeIntervalMinor = 1;

PFont plotFont; 

PImage photo;

void setup() {
  size(800, 600);
  
  data = new FloatTable("snowfall.tsv");
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount()-3;
  
  photo = loadImage("snow.png");
  
  dataMin = 0;
  

  // Corners of the plotted time series
  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 100;
  plotY2 = height - 70;
  labelY = height - 25;
  
  
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);

  smooth();
}


void draw() {
  background(224);
  
  // Show the plot area as a white box  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);
  image(photo, plotX1,plotY1,width - (plotX1 + (width -plotX2)),height - (plotY1 + (height -plotY2)));
  tint(255, 50);
  drawTitle();
  drawAxisLabels();
  
  //drawYearLabels();
  //drawVolumeLabels();
  drawDataPoints(currentRow);
  drawVolumeLabels();
  checkHover(currentRow);
  stroke(#5679C1);
  strokeWeight(5);
  //drawDataPoints(currentColumn);
  
  //make a variable called year that i increment for that 1 in value

  

  
}


void drawTitle() {
  fill(0);
  textSize(20);
  textAlign(CENTER);
  String title = data.getRowName(currentRow);
  text("Snowfall in Long Island, New York", (plotX1+plotX2)/2, plotY1 - 40);
  text(title, (plotX1+plotX2)/2, plotY1 - 10);
    rectMode(CENTER);
    

   fill(200);
  //rect((plotX1+plotX2)/2-40, plotY1-16, 25,25);
  //rect((plotX1+plotX2)/2+40, plotY1-16, 25,25);
  fill(0);
  textSize(30);
  text("-",(plotX1+plotX2)/2-40, plotY1-10);
  text("+",(plotX1+plotX2)/2+40, plotY1-8);
  //text();

}


void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  // Use \n (enter/linefeed) to break the text into separate lines
  text("Snowfall\ninches", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}


void drawYearLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);

}


void drawVolumeLabels() {
  fill(0);
  textSize(10);
  
  stroke(128);
  strokeWeight(1);
  

  
  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
  
    if (v % volumeIntervalMinor == 0) {     // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);  
      if (v % volumeInterval == 0) {        // If a major tick mark
        if (v == dataMin) {
          textAlign(RIGHT);                 // Align by the bottom
        } else if (v == dataMax) {
          textAlign(RIGHT, TOP);            // Align by the top
        } else {
          textAlign(RIGHT, CENTER);         // Center vertically
        }
        text(floor(v), plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } else {
        // Commented out, too distracting visually
        line(plotX1 - 2, y, plotX1, y);   // Draw minor tick
      }
    }
  }
}




void keyPressed() {
  if (key == 'a') {
    currentRow--;
    if (currentRow < 0) {
      currentRow = rowCount - 1;
    }
  } else if (key == 'd') {
    currentRow++;
    if (currentRow == rowCount) {
      currentRow = 0;
    }
  }
}



void drawDataPoints(int row) { 
  
 float total =0; 
  
  dataMax =  dataMax = ceil(data.getRowMax(row) / volumeInterval) * volumeInterval;
  //println(dataMax);
  beginShape();
  vertex(plotX1,plotY2);
   for (int i = 0; i < columnCount; i++) {
      
      float value = data.getFloat(row,i );
      //println(value);
      float x = map(i, columnCount,0,plotX2,plotX1+45);
      //ellipse(plotX1,plotY2,5,5);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      fill(205,81,100);
      ellipse(x,y,4,4);
      fill(0);
      vertex(x, y);
      //ellipse(x,y,5,5);
      textAlign(CENTER);
      fill(0);
      text(data.getColumnName(i),x,plotY2+15);
     if(data.isValid(row, i)){ 
      total = total + value;
     }

      
    
  }
  vertex(plotX2,plotY2);
  fill(205,81,100);
  endShape(CLOSE);
  
  
  textAlign(CENTER);
  textSize(14);
  textMode(SCREEN);
   fill(0);
  text(nf(total,0,2) + " in",(plotX1+plotX2)/2,plotY2+60);

}

void checkHover(int row) {
     for (int i = 0; i < columnCount; i++) {
      
      float value = data.getFloat(row,i );

      float x = map(i, columnCount,0,plotX2,plotX1+45);

      float y = map(value, dataMin, dataMax, plotY2, plotY1);

     if(data.isValid(row, i)){ 
      
     }
       if (dist(mouseX, mouseY, x, y) < 5) {
         fill(255);
        strokeWeight(10);
        ellipse(x,y,5,5);
        fill(0);
        textSize(13);
        textAlign(CENTER);
        rectMode(CENTER);
        noStroke();
        fill(255);
        rect(x,y-10,90,30);
        fill(205,81,100);
        ellipse(x,y,5,5);
        fill(0);
        
        text(nf(value, 0, 2) + " in (" + data.getRowName(row) + ")", x, y-8);
        
        
        textAlign(LEFT);
      }
      
    
  }
}

void moveTime() {
    
   if (dist(mouseX, mouseY,( plotX1+plotX2)/2-40, plotY1-16) < 10 ) {
        currentRow--;
    if (currentRow < 0) {
      currentRow = rowCount - 1;
    }
        
      }
      
      if (dist(mouseX, mouseY,( plotX1+plotX2)/2+40, plotY1-16) < 10 ) {
        currentRow++;
    if (currentRow == rowCount) {
      currentRow = 0;
    }
        
      }
}
void mousePressed() {
  moveTime();
}

