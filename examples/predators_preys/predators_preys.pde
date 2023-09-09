import java.util.ArrayList;

/*
Boidに関する変数
*/
Boids boids;//boid配列オブジェクト
Predators predators;
Preys preys;
static int   POPULATION     = 50;       //個体数
static float BODY_SIZE      = 15;        //体長
       color BODY_COLOR     = color(200);//体色
       color PREDATOR_COLOR = color(200, 100, 100);
       color PREY_COLOR     = color(100, 200, 100);
static float BODY_WEIGHT    = 1;         //体重
static float SENSOR_RADIUS  = 80;        //知覚範囲 default:80
static float FIXED_SPEED    = 2.5;       //速さ default:2.5


/*
描画設定
*/
color BACK_COLOR = color(30);//背景色


void setup() {
  size(960, 540);
  //boids = new Boids(POPULATION, BODY_SIZE, BODY_COLOR, BODY_WEIGHT, SENSOR_RADIUS, FIXED_SPEED);//boids呼び出し
  predators = new Predators(POPULATION, BODY_SIZE, PREDATOR_COLOR, BODY_WEIGHT, SENSOR_RADIUS, FIXED_SPEED);
  preys     = new Preys    (POPULATION, BODY_SIZE, PREY_COLOR,     BODY_WEIGHT, SENSOR_RADIUS, FIXED_SPEED);
  setParams(predators);//「params」タブで指定したパラメータを設定
  setParams(preys);
}

void draw() {
  background(BACK_COLOR);
  drawMouse();
  //boids.draw();
  predators.draw(preys);
  preys.draw();
}
