class Plate {
  private PVector pos; // Position
  private PVector size; // Taille
  private PVector rot; // Rotation
  
  private float va = PI /  144f; // Vitesse de rotation
  private float da = PI / 1440f; // Accélération de rotation
  private final float MIN_ANGLE = -PI / 3f; // Angle minimum
  private final float MAX_ANGLE =  PI / 3f; // Angle maximum
  private final float MIN_SPEED = PI / 720f;
  private final float MED_SPEED = PI / 144f;
  private final float MAX_SPEED = PI /  96f;
  
  // Positions des bords du plateau
  private float plateXMin = 0f;
  private float plateXMax = 0f;
  private float plateYMin = 0f;
  private float plateYMax = 0f;
  
  private boolean isShiftMode = false; // true : Mode Shift activé
  private PVector tmpRot = new PVector(0f, 0f, 0f); // Stoque le vecteur de rotation lors du SHIFT appuyé
  private ArrayList<PVector> obstacles; // Obstacles sur le plateau

  public Plate() {
    this(new PVector(500f, 20f, 500f));
  }
  public Plate(PVector size) {
    this(size, new PVector(0f, 0f, 0f), new PVector(width/2f, height/2f, 0f) );
  }
  private Plate(PVector size, PVector rot, PVector pos) {
    this.pos = pos;
    this.size = size;
    this.rot = rot;
    this.obstacles = new ArrayList();
    
    plateXMin = pos.x - size.x/2;
    plateXMax = pos.x + size.x/2;
    plateYMin = pos.y - size.z/2;
    plateYMax = pos.y + size.z/2;
  }
  
  public void display() {
    fill(200, 200, 255);
   
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateZ(rot.z);
    box(size.x, size.y, size.z);
    
    for(PVector cPos : obstacles) {
      pushMatrix();
      Cylinder c = new Cylinder();
      translate(cPos.x, 0, cPos.y);
      shape(c.get());
      popMatrix();
    }
  }
  
  // Affiche les informations speed, rotationX,Y en haut de la fenetre
  public void displayInfo() {
    fill(0, 0, 0);
    textSize(12);
    
    float speed = va / MED_SPEED;
    text("RotationX : "+nf(degrees(rot.x), 0, 1), 0, 15, 0);
    text("RotationZ : "+nf(degrees(rot.z),0,1), 130, 15, 0);
    text("Speed : "+nf(speed,0,1), 250, 15, 0);
  }
  
  public void mouseWheelEvent(float e) {
    this.va = Utils.clamp(va - e * da, MIN_SPEED, MAX_SPEED);
  }

  public void mouseDraggedEvent() {
    if(!isShiftMode) {
      float dy = -Utils.clamp(mouseY - pmouseY, -1, 1);
      float dx =  Utils.clamp(mouseX - pmouseX, -1, 1);
      
      rot.x = Utils.clamp(rot.x + dy * va, MIN_ANGLE, MAX_ANGLE);
      rot.z = Utils.clamp(rot.z + dx * va, MIN_ANGLE, MAX_ANGLE);
    }
  }
  
  // Active/Désactive le mode d'ajout d'obtacles selon la valeur du paramètre
  public void shiftMode(boolean on) {
      if(on) { // Active le mode SHIFT
        isShiftMode = true;
        tmpRot = new PVector(rot.x, rot.y, rot.z);
        rot = new PVector(-PI/2f, 0f, 0f);
      } else { // Désactive le mode SHIFT
        isShiftMode = false;
        rot = new PVector(tmpRot.x, tmpRot.y, tmpRot.z);
      }
  } 
  // Indique si on est en mode ajout d'obstacle ou non
  public boolean isShiftMode() {
     return isShiftMode; 
  }
  
  // Ajoute un obstacle sur le plateau
  public void addObstacle() {
      if(isInPlate(mouseX, mouseY)) {
        PVector position = new PVector(mouseX-this.size.x, mouseY-this.size.z);
        this.obstacles.add(position);
      }
  }
  
  // Indique si la position (x,y) est a l'intérieur du plateau
  public boolean isInPlate(float x, float y) {
    return (x >= plateXMin && x <= plateXMax && y >= plateYMin && y <= plateYMax); 
  }
  
  // Retourne les obstacles du plateau
  public ArrayList<PVector> getObstacles() {
    return obstacles;
  }
}