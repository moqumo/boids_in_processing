/*
マウス描画
*/
void drawMouse(){
  fill(250, 0, 0, 80);
  ellipse(mouseX, mouseY , 30, 30);
}


/*
指定された範囲のランダムなPVectorを生成
*/
PVector rand_PVector(float min, float max){
  PVector ret = new PVector();
  //ランダムな初期位置を設定
  ret.x = random(min, max);
  ret.y = random(min, max);
  return ret;
}
PVector rand_PVector(float x_min, float x_max, float y_min, float y_max){
  PVector ret = new PVector();
  //ランダムな初期位置を設定
  ret.x = random(x_min, x_max);
  ret.y = random(y_min, y_max);
  return ret;
}


/*
pythonのrange関数（拡張for文用）
*/
int[] range(int size){
  /*例...size = 3 -> ret[] = {0,1,2}*/
  int ret[] = new int[size];
  for(int i=0; i<size; i++) ret[i] = i;
  return ret;
}
int[] range(int min, int max){
  int ret[] = new int[max - min];
  for(int i = min; i< max; i++) ret[i] = i;
  return ret;
}
int[] range(int start, int end, int step){
  int ret[] = new int[(start - end)/step];
  for(int i = start; i< end; i+=step) ret[i] = i;
  return ret;
}

/*
Affine 変換
*/

//平行移動
PVector my_translate(PVector vec, PVector pos){
  return new PVector(vec.x + pos.x, vec.y + pos.y);
}

// 回転
PVector my_rotate(PVector vec, float angle){
  return new PVector(vec.x*cos(angle)-vec.y*sin(angle), 
                     vec.x*sin(angle)+vec.y*cos(angle)); 
}
