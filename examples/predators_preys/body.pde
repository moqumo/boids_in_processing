/*
描画用のボディ
*/
void arrowBody(PVector pos, PVector vel, float body_size /*,ColorMode = "RGB"*/){
    float rotate = vel.heading(); 
    float angle = rotate*180/PI;
    
    /*
    HSBで群れを視覚的に分類する時に使用。
    if(true){
      colorMode(HSB, 360, 100, 100);
      float hue = map(angle, -180, 180, 0, 360);
      fill(hue, 100, 100);
    }
    */
    
    //座標系を変換
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotate);
    
    //描画
    noStroke();
    triangle(body_size, 0, -body_size*cos(PI/6), body_size*sin(PI/6), -body_size*cos(PI/6), -body_size*sin(PI/6));
    
    //座標系とカラーモードを通常の状態へ戻す
    colorMode(RGB, 256);
    rotate(-rotate);
    popMatrix();
}
