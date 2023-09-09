class Preys extends Boids{
  public Preys(int _population, float body_size, color body_color, float body_weight, float sensor_radius, float fixed_speed){
    super(_population, body_size, body_color, body_weight, sensor_radius, fixed_speed);
  }
  
  /*
  描画
  */
  public void draw(){
    for(Boid boid : super.array){
      //流れるようなインターフェース：次々順番に実行
      boid
        .countNearEntity(this)//周囲の個体数をカウント
        .flock(this)          //群れ行動
        .fleeWall()           //壁避け
        .flee(new PVector(mouseX, mouseY))//マウスから逃げる
        .flee(predators)
        .death()              //死
        .move()               //位置更新
        .draw();              //描画
    }
    this.deaths();//死んだboidオブジェクトを削除
  }
}
