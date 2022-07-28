float cellSize;
int padding = 50; 
int m = 500;
String mode;

//CHANGE THESE VARIABLES
int n = 100;
int fr = 5;
int numFlower = 1000;  
int numHummingbird = 200;
int numPredators = 30;
int numNest = 50;

//ARRAYS
color[][] cells = new color[n][n];

int[] NestX = new int[numNest]; 
int[] NestY = new int[numNest]; 

int[] flowerX = new int[m * m];
int[] flowerY = new int[m * m];
boolean[] flowerAlive = new boolean[m * m];

int[] birdX = new int[m * m];
int[] birdY = new int[m * m];
boolean[] birdAlive = new boolean[m * m];

int[] predX = new int[m * m];
int[] predY = new int[m * m];
boolean[] predAlive = new boolean[m * m];

//COLOURS
color green = color(150, 232, 32), pink = color(255, 110, 251), yellow = color(255, 243, 39), black = color(0), brown = color(110, 83, 1);


void setup() {
  size(800, 800);
  frameRate(fr); 
  cellSize = (width-2*padding)/n; 

  // Initially draws green field
  for (int i = 0; i < n; i++ ) {
    for (int j =0; j < n; j++) {
      cells[i][j] = green;
    }
  }

  mode = "nature";  // "nature", "chaotic"

  //Draws other cells
  setFlowerCellsRandomly();  
  setHummingbirdCellsRandomly();
  setPredatorCellsRandomly();
  setNestCellsRandomly();
}


void draw() {  
  noStroke();

  for (int i = 0; i < n; i++ ) {
    for (int j =0; j < n; j++) {

      float x = padding + i*cellSize; 
      float y = padding + j*cellSize;

      fill(cells[i][j]); 

      rect(x, y, cellSize, cellSize);  //Draws the current cell
    }
  }
  nextMove();
  drawNext();
  actionToNeighbours();
  Death();
}

// INITIAL DRAWING OF FLOWERS (PINK)
void setFlowerCellsRandomly() {
  for (int f = 0; f < numFlower; f++) {
    int ranI = round(random(n-1));
    int ranJ = round(random(n-1));

    flowerX[f] = ranI;
    flowerY[f] = ranJ;
    flowerAlive[f] = true;
    cells[ranI][ranJ] = pink;
  }
}

//INITIAL DRAWING OF HUMMINGBIRDS (YELLOW)
void setHummingbirdCellsRandomly() {
  for (int h = 0; h < numHummingbird; h++) {
    int ranI = round(random(n-1));
    int ranJ = round(random(n-1));

    birdX[h] = ranI;
    birdY[h] = ranJ;
    birdAlive[h] = true;
    cells[ranI][ranJ] = yellow;
  }
}

// INITIAL DRAWING OF PREDATORS (BLACK)
void setPredatorCellsRandomly() {
  for (int p = 0; p < numPredators; p++) {
    int ranI = round(random(n-1));
    int ranJ = round(random(n-1));

    predX[p] = ranI;
    predY[p] = ranJ;
    predAlive[p] = true;
    cells[ranI][ranJ] = black;
  }
}

//INITIAL DRAWING OF NESTS (BROWN)
void setNest(int i, int j) {
  for (int a = i; a < i+2; a++) {
    for (int b = j; b < j+2; b++) {
      cells[a][b] = brown;
    }
  }
}  

// FINDS POSITIONS AND DRAWS THE NESTS
void setNestCellsRandomly() {
  int[] value = new int[(n - 1) * (n - 1)]; // Positions cannot be in the far right lane and bottom lane

  for (int v = 0; v < value.length; v++)
    value[v] = v;

  for (int v = 0; v < value.length; v++) {  // Prevents repeating random numbers 
    int rand = (int)random(0, value.length - 1);
    int temp = value[v];

    value[v] = value[rand];
    value[rand] = temp;
  } 

  for (int v = 0; v < numNest; v++) {  // Finds x and y coordinates
    int x = value[v] / (n - 1);
    int y = value[v] % (n - 1);

    NestX[v] = x;
    NestY[v] = y;
    setNest(x, y);
  }
}

//SETS THE MOVEMENT OF THE CELLS
void nextMove() {

  //How the hummingbird cells will move
  for (int i = 0; i < numHummingbird; i++) {
    float b;
    int dx;
    int dy;
    int x = birdX[i];
    int y = birdY[i];

    //The hummingbird cells moves randomly
    b = random(0, 1);
    if (b > 0.5)
      dx = 1;

    else
      dx = -1;

    b = random(0, 1);
    if (b > 0.5)
      dy = 1;

    else
      dy = -1;

    //Prevents hummingbirds from going out of the screen        
    if (x + dx < 0)
      dx = 1;

    if (x + dx > n - 1) 
      dx = -1;

    if (y + dy < 0) 
      dy = 1;

    if (y + dy > n - 1) 
      dy = -1;

    // Prevents hummingbirds from merging with other cells  
    if (cells[x+dx][y+dy] == brown || cells[x+dx][y+dy] == pink || cells[x+dx][y+dy] == black) {
      dx = 0;
      dy = 0;
    }

    birdX[i] += dx;
    birdY[i] += dy;
  }

  // How the predator cells will move
  for (int i = 0; i < numPredators; i++) {
    float b;
    int dx;
    int dy;
    int x = predX[i];
    int y = predY[i];

    //The predator cells moves randomly
    b = random(0, 1);
    if (b > 0.5)
      dx = 1;

    else
      dx = -1;

    b = random(0, 1);
    if (b > 0.5)
      dy = 1;

    else
      dy = -1;

    //Prevents predators from going out of the screen          
    if (x + dx < 0)
      dx = 1;

    if (x + dx > n - 1) 
      dx = -1;

    if (y + dy < 0) 
      dy = 1;

    if (y + dy > n - 1) 
      dy = -1;

    // Prevents predators from merging with other cells 
    if (cells[x+dx][y+dy] == brown || cells[x+dx][y+dy] == pink || cells[x+dx][y+dy] == yellow) {
      dx = 0;
      dy = 0;
    }

    predX[i] += dx;
    predY[i] += dy;
  }
}

// DRAWS THE NEXT GENERATION
void drawNext() {

  // Field cells
  for (int i = 0; i < n; i++ ) {
    for (int j =0; j < n; j++) {
      cells[i][j] = green;
    }
  }

  //Flower cells 
  for (int i = 0; i < numFlower; i++) {
    int x = flowerX[i];
    int y = flowerY[i];

    if (flowerAlive[i] == true) {
      cells[x][y] = pink;
    }
  }

  //Nest cells
  for (int i = 0; i < numNest; i++) {
    int x = NestX[i];
    int y = NestY[i];

    setNest(x, y);
  }

  // Hummingbird cells
  for (int i = 0; i < numHummingbird; i++) {
    int x = birdX[i];
    int y = birdY[i];

    if (birdAlive[i] == true)
      cells[x][y] = yellow;
  }

  // Predator cells
  for (int i = 0; i < numPredators; i++) {
    int x = predX[i];
    int y = predY[i];

    if (predAlive[i] == true)
      cells[x][y] = black;
  }
}


//FINDS POSITION OF NEIGHBORING YELLOW CELLS
int[] getYellowPos(int i, int j) {
  int[] posY = new int[2];
  posY[0] = -1;
  posY[1] = -1;

  for (int a = -1; a <= 1; a++) {   
    for (int b = -1; b <= 1; b++) {   
      if (a != 0 || b != 0) {

        try {
          if (cells[i + a][j + b] == yellow) {
            posY[0] = i + a;
            posY[1] = j + b;
            return posY;
          }
        }
        catch(Exception e) {
        }
      }
    }
  }
  return posY;
}

//FINDS POSITION OF NEIGHBORING BLACK CELLS
int[] getBlackPos(int i, int j) {
  int[] posB = new int[2];
  posB[0] = -1;
  posB[1] = -1;

  for (int a = -1; a <= 1; a++) {   
    for (int b = -1; b <= 1; b++) {   
      if (a != 0 || b != 0) {

        try {
          if (cells[i + a][j + b] == black) { 
            posB[0] = i + a;
            posB[1] = j + b;
            return posB;
          }
        }
        catch(Exception e) {
        }
      }
    }
  }
  return posB;
}

//FINDS POSITION OF NEIGHBORING PINK CELLS
int[] getPinkPos(int i, int j) {
  int[] posP = new int[2];
  posP[0] = -1;
  posP[1] = -1;

  for (int a = -1; a <= 1; a++) {   
    for (int b = -1; b <= 1; b++) {   
      if (a != 0 || b != 0) {

        try {
          if (cells[i + a][j + b] == pink) {
            posP[0] = i + a;
            posP[1] = j + b;
            return posP;
          }
        }
        catch(Exception e) {
        }
      }
    }
  }
  return posP;
}

// COUNTS THE NUMBER OF NEIGHBOURING GREEN CELLS
int getGreenNum(int i, int j) {
  int greenNum = 0;

  for (int a = -1; a <= 1; a++) {
    for (int b = -1; b <= 1; b++) {

      try {
        if (cells[i+a][j+b] == green && (a != 0 || b != 0))
          greenNum++;
      }
      catch(Exception e) {
      }
    }
  }
  return greenNum;
}

//FINDS POSITION OF NEIGHBORING GREEN CELLS
int[] getGreenPos(int i, int j) {
  int greenNeighbours = getGreenNum(i, j);
  int count = 0;
  int[] posG = new int[2];
  int [] store1 = new int[greenNeighbours]; 
  int [] store2 = new int[greenNeighbours];
  posG[0] = -1;
  posG[1] = -1;

  try {
    for (int a = -1; a <= 1; a++) {   
      for (int b = -1; b <= 1; b++) {   
        if (a != 0 || b != 0) {
          if (cells[i + a][j + b] == green) {  // Stores the x and y coordinates in arrays
            store1 [count] = i + a;
            store2 [count] = j + b;
            count++;
          }
        }
      }
    }
    int random = round(random(0, count-1));  // Chooses a random number(the max number being the number of neighbouring green cells there are in total)
    posG[0] = store1[random];
    posG[1] = store2[random];
  }
  catch(Exception e) {
  }
  return posG; //returns a random position of any neighboring green cells
}


//FINDS POSITION OF NEIGHBORING GREEN CELLS AROUND THE BROWN CELLS (USED FOR REPRODUCTION OF HUMMINGBIRDS)
int[] getReproducePos(int i, int j) {
  int[] posR = new int[2];
  posR[0] = -1;
  posR[1] = -1;

  int rand = (int)random(0, numNest);
  int randx = round(random(0, 2));
  int randy = round(random(0, 2));

  try {
    int[] posG = getGreenPos(NestX[rand] + randx, NestY[rand] + randy);
    posR[0] = posG[0];
    posR[1] = posG[1];
    return posR;
  }
  catch(Exception e) {
  }
  return posR;
}


//ACTIONS WHEN DETECTING DIFFERENT CELLS NEARBY
void actionToNeighbours() {

  //CHANCES 
  float c;
  float eatingHum = 0.4;
  float eatingPre = 0.75;
  float destoryFlo = 0.3;
  float pollination = 0.5;    
  float reproduce = 0.85;
  float humMate = 0.3; 
  float predMate;

  if (mode == "nature")
    predMate = 0.06;

  else 
  predMate = 0.3; 

  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {

      if (cells[i][j] == black) {  

        if (mode == "nature") {

          int[] posY = getYellowPos(i, j) ; // When a black cell meets a yellow cell
          if (posY[0] != -1) { 
            c = random(0, 1);  

            if (c < eatingHum) {  // 40% of eating the hummingbird
              for (int b = 0; b < numHummingbird; b++) {
                if (birdX[b] == posY[0] && birdY[b] == posY[1])
                  birdAlive[b] = false;
              }
            }
          }
        }

        int[] posB = getBlackPos(i, j); //When a black cell meets another black cells
        if (posB[0] != -1) { 
          c = random(0, 1);   

          try {
            if (c < predMate) {   // 6% of mating and reproducing (nature mode), 30% of mating and reproducing (chaotic mode)         
              int[] posG = getGreenPos(i, j);
              if (posG[0] != -1) { 
                predX[numPredators] = posG[0];
                predY[numPredators] = posG[1];
                predAlive[numPredators] = true;
                numPredators++;
              }
            }
          }
          catch(Exception e) {
          }
        }
      }


      if (cells[i][j] == yellow) {  

        if (mode == "nature") {
          int[] posP = getPinkPos(i, j);   //When a yellow cell meets a pink cell
          if (posP[0] != -1) { 
            c = random(0, 1);  

            if (c < pollination) {   // 50% of pollinating flower
              c = random(0, 1);

              if (c < reproduce ) {   // 85% chance of reproducing
                try {
                  int[] posG = getGreenPos(i, j);
                  if (posG[0] != -1) {                
                    flowerX[numFlower] = posG[0];
                    flowerY[numFlower] = posG[1];
                    flowerAlive[numFlower] = true;
                    numFlower++;
                  }
                }
                catch(Exception e) {
                }
              }
            }
          }
        }

        int[] posY = getYellowPos(i, j) ; //When yellow cell meets another yellow cell
        if (posY[0] != -1) {      
          c = random(0, 1);   

          if (c < humMate) {    // 30% of mating and reproducing
            try {
              int[] posR = getReproducePos(i, j) ;
              if (posR[0] != -1) {  
                birdX[numHummingbird] = posR[0];
                birdY[numHummingbird] = posR[1];
                birdAlive[numHummingbird] = true;
                numHummingbird++;
              }
            }
            catch(Exception e) {
            }
          }
        }

        if (mode == "chaotic") {

          int[] posB = getBlackPos(i, j); // When a yellow cell meets a black cell
          if (posB[0] != -1) { 
            c = random(0, 1);   

            if (c < eatingPre) {    // 75% of eating the predators
              for (int b = 0; b < numPredators; b++) {
                if (predX[b] == posB[0] && predY[b] == posB[1]) 
                  predAlive[b] = false;
              }
            }
          }

          int[] posP = getPinkPos(i, j) ; // When a yellow cell meets a pink cell
          if (posP[0] != -1) { 
            c = random(0, 1);    

            if (c < destoryFlo) {   // 30% of eating the flowers
              for (int b = 0; b < numFlower; b++) {
                if (flowerX[b] == posP[0] && flowerY[b] == posP[1])
                  flowerAlive[b] = false;
              }
            }
          }
        }
      }
    }
  }
}

//NATURAL DEATH
void Death() {
  float d;
  float deathOfPre = 0.007;
  float deathOfHum = 0.04;
  float deathOfFlo = 0.08;

  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {

      if (cells[i][j] == black) {  
        d = random(0, 1);      

        if (d < deathOfPre) {    // Predators have 0.7% chance of death
          for (int b = 0; b < numPredators; b++) {
            if (predX[b] == i && predY[b] == j)
              predAlive[b] = false;
          }
        }
      }

      if (cells[i][j] == yellow) {
        d = random(0, 1);    

        if (d < deathOfHum) {   // Hummingbirds have 4% chance of death
          for (int b = 0; b < numHummingbird; b++) {
            if (birdX[b] == i && birdY[b] == j)
              birdAlive[b] = false;
          }
        }
      }

      if (cells[i][j] == pink) {
        d = random(0, 1);      

        if (d < deathOfFlo) {    // FLowers have 8% of death
          for (int b = 0; b < numFlower; b++) {
            if (flowerX[b] == i && flowerY[b] == j)
              flowerAlive[b] = false;
          }
        }
      }
    }
  }
}
