import javax.swing.JOptionPane;
PImage map;
String[] rows;
ArrayList<Marker> markers = new ArrayList<Marker>();
    int minPopulation = Integer.MAX_VALUE;
    int maxPopulation = Integer.MIN_VALUE;
void setup() {
  size(430, 413);
  map = loadImage("emap.jpg"); // Load the map image
  rows = loadStrings("data.tsv"); // Load TSV file

  for (int i = 0; i < rows.length; i++) {
  String[] columns = split(rows[i], '\t');
  String governorate = columns[0];
  float x = float(columns[1]); // Assuming these are pixel coordinates
  float y = float(columns[2]); // Assuming these are pixel coordinates
  String populationString = columns[3].replace(",","");
  int population = 0; // Default value
  if (!populationString.isEmpty()) { // Check if the string is not empty
    population = Integer.parseInt(populationString);
    minPopulation = min(minPopulation, population);
    maxPopulation = max(maxPopulation, population);
  }

  Marker marker = new Marker(x, y, governorate, population);
  markers.add(marker);
}
  map.resize(width, height); // Resize the image to the size of the window
}

void draw() {
  background(map);
  for (Marker marker : markers) {
    marker.display();
    if (marker.isInside(mouseX, mouseY)) {
      String message = "Governorate: " + marker.governorate + ", Population: " + marker.population;
      fill(0); // Set the text color to black
      text(message, 10, 2*height/3); 
    }
  }

  // Draw color bar
  int barWidth = 20;
  int barHeight = height - 50;
  int barX = width - barWidth - 20;
  int barY = 25;
  for (int i = 0; i < barHeight; i++) {
    float ratio = i / (float)barHeight;
    int colorValue = (int)map(ratio, 0, 1, 0, 255);
    stroke(255 - colorValue, 0, colorValue);
    line(barX, barY + i, barX + barWidth, barY + i);
  }

  // Draw color bar labels
  fill(0);
  text("High", barX, barY - 5);
  text("Low", barX, barY + barHeight + 15);
}


void mouseClicked() {
  for (Marker marker : markers) {
    if (marker.isInside(mouseX, mouseY)) {
      String message = "Governorate: " + marker.governorate + ", Population: " + marker.population;
      JOptionPane.showMessageDialog(null, message);
    }
  }
}

class Marker {
  float x, y;
  String governorate;
  int population;

  Marker(float x, float y, String governorate, int population) {
    this.x = x;
    this.y = y;
    this.governorate = governorate;
    this.population = population;
  }

 void display() { // part of the refine
  float colorValue = map(population, minPopulation, maxPopulation, 0, 255);
  fill(colorValue, 0, 255 - colorValue);
  ellipse(x, y, 10, 10);
}

  boolean isInside(float mx, float my) {
    return dist(mx, my, x, y) < 5;
  }
}
