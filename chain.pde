float grav = 0;
float drag = 1000;
int divs = 10000;

int segments = 200;

//Proj a/B
/*PVector proj(PVector _a, PVector _b)
{
  float sc = _a.dot(_b);
  sc /= _b.dot(_b);
  PVector result = _b.copy();
  result.mult(sc);
  return result;
}*/

class rope
{
  PVector tip = new PVector(400, 100);
  int segNum = segments;
  float segLen = 15; // Segments
  float segMass = 50;
  obj[] seg;
  spring[] segSpr;
  
  void load()
  {
   seg = new obj[segNum];
   segSpr = new spring[segNum-1];
   
   for(int i = 0; i < seg.length; i++)
   {
     seg[i] = new obj(tip.x+i, tip.y + segLen*i, segMass);
   }
   
   for(int i = 0; i < seg.length-1; i++)
   {
     segSpr[i] = new spring(seg[i], seg[i+1], segLen, 1000000000, 30000);
   }
   
   seg[0].fixed = false;
  }
  
  void update()
  {
    for(int i = 0; i < seg.length; i++) seg[i].clearAcc();
    
    for(int i = 0; i < segSpr.length; i++) segSpr[i].update();
    
    for(int i = 0; i < seg.length; i++) seg[i].update();
   
  }
}


class obj
{
  obj(float _x, float _y, float _m)
  {
    pos = new PVector(_x, _y);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
    mass = _m;
    c = color(random(255),random(255),random(255));
    enableGrav = true;
  }
  
  boolean enableGrav = true;
  boolean fixed = false;
  
  void clearAcc()
  {
   accel.mult(0); 
  }
  
  void applyForce(PVector _f)
  {
    PVector _accel = _f.copy();
    _accel.div(mass);
    accel.add(_accel);
  }
  
  color c;
  PVector pos;
  PVector vel;
  PVector accel;
  
  float mass;
  
  
  
  
  void update()
  {
    if(enableGrav) accel.y += grav;
    
    PVector _drag = vel.copy();
    _drag.normalize();
    _drag.mult(-drag*drag);
    applyForce(_drag);
    
    PVector dAcc = accel.copy();
    dAcc.div(divs);
    if(!fixed) vel.add(dAcc);
    
    PVector dVel = vel.copy();
    dVel.div(divs);
    if(!fixed) pos.add(dVel);
    if(keyPressed) vel.mult(0);
    
    //draw
    float r = 10;
    noStroke();
    fill(c);
    circle(pos.x, pos.y, r);
  }
};

class spring
{
 obj a, b;
 float len;
 float k;
 float D;
 
 spring(obj _a, obj _b, float _l, float _s, float  _D)
 {
   a = _a;
   b = _b;
   len = _l;
   k = _s;
   D = _D;
 }
 
  void update()
  {
   PVector spr = a.pos.copy();
   spr.sub(b.pos);
   
   
   
   float delta = spr.mag() - len;
   spr.normalize();
   
   PVector dmp = spr.copy();
   
   if(delta != 0)
   {
     spr.mult(delta*k);
     
     PVector vRel = a.vel.copy();
     vRel.sub(b.vel);
     float ang = PVector.angleBetween(vRel, dmp);
     float relVel = vRel.mag();
     relVel *= cos(ang);
     
     
     dmp.mult(relVel*D);
     
     spr.add(dmp);
     
     b.applyForce(spr);
     spr.mult(-1);
     a.applyForce(spr);
     
   }
  }
}

rope r1;

void setup()
{
  size(1080,1080);
  frameRate(999999999);
  r1 = new rope();
  r1.load();
  r1.seg[r1.seg.length-1].mass *=1;
  r1.seg[r1.seg.length-1].fixed=true;
}


void draw()
{
  background(0);


  r1.update();
  
  
if(mousePressed)
{
 PVector mouse = new PVector(mouseX, mouseY);
 /*force.sub(mouse);
 force.mult(-1);
 force.normalize();
 force.mult(1000000);
 D.applyForce(force);*/
 
 r1.seg[r1.seg.length-1].pos.x = mouseX;
 r1.seg[r1.seg.length-1].pos.y = mouseY;
 r1.seg[r1.seg.length-1].vel.mult(0);

}
  
}
