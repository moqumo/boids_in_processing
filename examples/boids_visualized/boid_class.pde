/*
参考...群れ形成の動力学：https://www.jstage.jst.go.jp/article/sicejl/52/3/52_234/_pdf
*/

class Boid {
  private PVector pos, vel;
  private PVector acc = new PVector(0,0,0);
  private PVector force = new PVector(0,0,0);
  
  private float body_size;
  private color body_color;
  private float weight;
  
  private float sensor_radius;
  private float default_speed;
  
  public int near_entity_count = 0;//周囲にいる個体数
  public boolean isLife = true;    //生きているかどうか
  private HashMap <String, Float>params;//パラメータ格納用HashMap

  /*
  コストラクタ：
  pos: 位置ベクトル
  vel: 速度ベクトル
  acc: 加速度ベクトル
  body_size: 体長
  sensor_radius: 知覚範囲（視野）
  setted_mag: 速度ベクトルの上限
  */
  Boid(PVector _pos, PVector _vel, float _body_size, color _body_color,float _weight, float _sensor_radius) {
    this.pos = _pos;
    this.vel = _vel;
    this.default_speed = this.vel.mag();
    this.body_size = _body_size;
    this.body_color = _body_color;
    this.weight = _weight;
    this.sensor_radius = _sensor_radius;
    
    //paramsの規定値を設定
    this.params = new HashMap();
    this.initParams();
  }
  
  
  /*
  リセット
  */
  public void reset(){
    this.acc.set(0,0,0);  //acc = 0
    this.force.set(0,0,0);//force = 0
    this.near_entity_count = 0; 
  }
  
  
  /*
  params(HashMap)用のメソッド
  */
  //パラメータを代入するメソッド
  public void putParam(String Key, float value){
    this.params.put(Key, value);  
  }
  //パラメータを取り出すメソッド
  float getParam(String Key){
   return params.get(Key); 
  }
  
  /*
  パラメータを規定値に初期化するメソッド
  !!!: 値は変更しないこと。変更するときは、void setParams(Boid)から
  */
  public void initParams(){
    this.putParam("separate",  0.2); //分離
    this.putParam("alignment", 0.08);//整列
    this.putParam("cohesion",  0.05); //結合
    this.putParam("wall",      3.0); //壁回避
    this.putParam("flee",      0.3); //回避行動
    this.putParam("chase",     0.3); //追尾行動
    this.putParam("force",     0.6); //力
  }
  
  
  /*
  距離計算
  */
  private float dist(PVector other_entity_pos){
    return PVector.dist(this.pos, other_entity_pos);
  }
  
  /*
  周囲(知覚範囲より近い場所)にいる個体数を数える
  */
  public Boid countNearEntity(Boids boids){
    for(Boid b : boids.array){
      if(0 < this.dist(b.pos) && this.dist(b.pos) < this.sensor_radius){
        this.near_entity_count += 1;
      }
    }
    return this;
  }
  
  
  /*
  引力
  */
  private PVector attraction_with(PVector pos_other){
    float dist = this.pos.dist(pos_other);
    //知覚範囲に入ったら、引力を計算して返す
    if(0 < dist && dist < this.sensor_radius){
      return PVector.sub(pos_other, this.pos).div(sq(dist)).mult(this.sensor_radius);  
    }else{
      return new PVector(0,0,0); 
    }
  }
  
  
  /*
  壁を避ける
  */
  public Boid fleeWall() {
    float sum_force_x = 0, sum_force_y = 0;//一時的な値
    
    //x軸方向
    if (this.pos.x + this.sensor_radius > width) sum_force_x = -this.default_speed/(width - this.pos.x);
    if (this.pos.x - this.sensor_radius < 0)     sum_force_x = this.default_speed/( pos.x - 0);
    
    //y軸方向
    if (this.pos.y + this.sensor_radius > height) sum_force_y = -this.default_speed/(height - this.pos.y);
    if (this.pos.y - this.sensor_radius < 0)      sum_force_y = this.default_speed/( this.pos.y - 0);
    
    //x,y軸方向の力を加算
    PVector sum_force = new PVector(sum_force_x, sum_force_y);
    sum_force.mult(getParam("wall"));//重み乗算
    this.force.add(sum_force);
    
    return this;
  }
  

  /*
  逃避行動
  */
  //捕食者に対して
  public Boid flee(PVector predator_pos){
    PVector repulsive_force = new PVector(0,0,0);//斥力
    repulsive_force = this.attraction_with(predator_pos).mult(-1);
    repulsive_force.mult(getParam("flee"));//重み乗算
    this.force.add(repulsive_force);
    return this;
  }
  //Boid配列オブジェクトに対して
  public Boid flee(Boids boids){
    for(Boid b : boids.array){
      this.flee(b.pos);
    }
    return this;
  }
  
  
  /*
  追尾行動
  */
  //被食者に対して
  public Boid chase(PVector prey_pos){
    PVector attractive_force = new PVector(0,0,0);//引力
    attractive_force = this.attraction_with(prey_pos);
    attractive_force.mult(getParam("chase"));//重み乗算
    this.force.add(attractive_force);
    return this;
  }
  //Boid配列オブジェクトに対して
  public Boid chase(Boids boids){
    for(Boid b : boids.array){
      this.chase(b.pos);
    }
    return this;
  }
    
    
  /*
  分離
  */
  public Boid separate(Boids boids) {
    //周囲個体との位置ベクトルの差を計算
    PVector sum_repulusive_force = new PVector(0,0,0);
    for (Boid b : boids.array) {
      PVector tmp_repulusive_force = attraction_with(b.pos).mult(-1); //斥力
      sum_repulusive_force.add(tmp_repulusive_force);
    }
    //separate_forceを決定
    PVector separate_force = sum_repulusive_force.mult(getParam("separate"));//重み乗算
    this.force.add(separate_force);
    return this;
  }


  /*
  結合
  */
  public Boid cohesion(Boids boids) {
    //周囲個体の位置ベクトルの和を計算
    PVector sum_pos = new PVector(0,0,0);
    for (Boid b : boids.array) {
      float dist = this.dist(b.pos);//距離
      if ( 0 < dist && dist < this.sensor_radius) {
        sum_pos.add(b.pos);//位置ベクトルを加算
      }
    }
    
    if(this.near_entity_count > 0) { //0除算対策の条件
      //個体数に応じてsum_posの平均(周囲個体の重心)を計算->cohesion_forceを決定
      sum_pos.div(this.near_entity_count);
      PVector cohesion_force = PVector.sub(sum_pos, pos);
    
      cohesion_force.mult(getParam("cohesion"));//重み乗算
      this.force.add(cohesion_force);
    }
    
    return this;
  }
  
  
  /*
  整列
  */
  public Boid alignment(Boids boids){
    //周囲個体の速度ベクトルの和を計算
    PVector sum_vel = new PVector(0,0,0);
    for (Boid b : boids.array) {
      float dist = this.dist(b.pos);//距離
      if ( 0 < dist && dist < sensor_radius){
        sum_vel.add(b.vel);//速度ベクトルを加算
      }
    }
    
    if(this.near_entity_count > 0) { //0除算対策の条件
      //個体数に応じてsum_velの平均を計算->alignment_forceを決定
      sum_vel.div(this.near_entity_count);
      PVector alignment_force = PVector.sub(sum_vel, this.vel);
      
      alignment_force.mult(getParam("alignment"));//重み乗算
      this.force.add(alignment_force);
    }
    
    return this;
  }
  
  
  /*
  群れ（分離・結合・整列）
  */
  public Boid flock(Boids boids){
    this.separate(boids)
        .cohesion(boids)
        .alignment(boids);
    return this;
  }
  
  /*
  死ぬ条件
  */
  public Boid death(){
    int flg = 0;
    //if(this.dist(new PVector(mouseX, mouseY)) < 20) flg++; //マウスによる死亡
    if(flg > 0) this.isLife = false;
    return this; 
  }
  
  
  /*
  移動
  */
  public Boid move() {
    //速度調整: 速さがdefault_speedを超えたら調整
    if (this.vel.mag() > this.default_speed){
      this.vel.limit(this.default_speed);
    }
    
    //位置移動: 加速度->速度->位置
    this.acc.set(force.mult(getParam("force")).div(this.weight));//acc = force*force_w/weight
    this.vel.add(acc);//vel += acc
    this.pos.add(vel);//pos += vel
    
    return this;
  }

  
  /*
  描画
  */
  public Boid draw() {
    fill(body_color);
    arrowBody(this.pos, this.vel, this.body_size);
    this.reset();
    return this;
  }
}
