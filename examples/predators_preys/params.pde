/*
各パラメータ（定数）
*/
static float separate_w  = 0.2;  //分離
static float alignment_w = 0.5;//整列
static float cohesion_w  = 0.1;//結合 
static float wall_w      = 55;   //壁回避
static float flee_w      = 1.0; //回避行動
static float chase_w     = 0.3; //追尾行動
static float force_w     = 0.6; //力

/*
定数からパラメータを設定する場合
*/
void setParams(Boids boids){
  for(Boid b : boids.array){
      b.putParam("separate",  separate_w); //分離
      b.putParam("alignment", alignment_w);//整列
      b.putParam("cohesion",  cohesion_w); //結合
      b.putParam("wall",      wall_w); //壁回避
      b.putParam("flee",      flee_w); //回避行動
      b.putParam("chase",     chase_w); //追尾行動
      b.putParam("force",     force_w); //力
  }
}
