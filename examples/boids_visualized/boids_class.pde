/*
boid配列クラス
*/
class Boids{
  private ArrayList<Boid> array;
  private int population;//個体数
  
  /*
  コンストラクタ
  */
  public Boids(int _population, float body_size, color body_color, float body_weight, float sensor_radius, float fixed_speed){
    this.population = _population;
    this.array = new ArrayList<Boid>();
  
    for(int i : range(this.population)){
      //ランダムな初期位置を設定
      PVector tmp_pos = rand_PVector(0 + body_size, width - body_size, 0 + body_size, height - body_size);
      //ランダムな初期方向を設定
      PVector tmp_vel = rand_PVector(-1, 1);
      tmp_vel.normalize().mult(fixed_speed);//速度ベクトルの長さ(絶対値)がFIXED_LENGTHになるように正規化
    
      //インスタンス化
      this.add(new Boid(tmp_pos, 
                        tmp_vel, 
                        body_size, 
                        body_color, 
                        body_weight, 
                        sensor_radius)); 
    }
  }
  
  /*
  ArrayList用のメソッド
  */
  //指定されたboidオブジェクトのインデックスを取得
  public int indexOf(Boid b){
    return this.array.indexOf(b);
  }
  //指定されたインデックスの要素を取得
  public Boid get(int idx){
    return this.array.get(idx);
  }
  //boidオブジェクトを追加
  public void add(Boid boid){
    this.array.add(boid); 
  }
  //指定されたインデックスの要素を削除
  public void remove(int idx){
    this.array.remove(idx);
    this.population--;
  }
  //指定されたboidオブジェクトを削除
  public void remove(Boid boid){
    this.array.remove(indexOf(boid));
    this.population--;
  }
  
  /*
  死んだboidオブジェクトを削除
  */
  public void deaths(){
    int size = array.size();
    for(int i=size-1; i>=0; i--){//後ろから探索
      if(this.get(i).isLife == false) this.remove(i);
    }
  }
  
  /*
  描画
  */
  public void draw(){
    for(Boid boid : this.array){
      //流れるようなインターフェース：次々順番に実行
      boid
        .countNearEntity(this)//周囲の個体数をカウント
        .flock(this)          //群れ行動
        .fleeWall()           //壁避け
        //.flee(new PVector(mouseX, mouseY))//マウスから逃げる
        .death()              //死
        .move()               //位置更新
        .draw();              //描画
    }
    this.deaths();//死んだboidオブジェクトを削除
  }
}
