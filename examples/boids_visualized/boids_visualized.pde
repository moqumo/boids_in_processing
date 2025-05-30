import java.util.ArrayList;

/*
Boidに関する変数
*/
Boids boids;//boid配列オブジェクト
static int   POPULATION    = 50;       //個体数
static float BODY_SIZE     = 15;        //体長
       color BODY_COLOR    = color(200);//体色
static float BODY_WEIGHT   = 1;         //体重
static float SENSOR_RADIUS = 80;        //知覚範囲 default:80
static float FIXED_SPEED   = 2.0;       //速さ default:2.5


/*
描画設定
*/
color BACK_COLOR = color(30);//背景色

void setup() {
  size(960, 540);
  extraSettings(); // <PShapeTrace> 以下にプログラムを記述
  boids = new Boids(POPULATION, BODY_SIZE, BODY_COLOR, BODY_WEIGHT, SENSOR_RADIUS, FIXED_SPEED);//boids呼び出し
  //setParams(boids);//「params」タブで指定したパラメータを設定
}

void drawMain() {
  background(BACK_COLOR);
  //drawMouse();
  boids.draw();
}
