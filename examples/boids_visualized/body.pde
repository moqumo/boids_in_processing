/*
描画用のボディ
*/

PVector vertex1 = new PVector(BODY_SIZE, 0);
PVector vertex2 = new PVector(-BODY_SIZE*cos(PI/6), BODY_SIZE*sin(PI/6));
PVector vertex3 = new PVector(-BODY_SIZE*cos(PI/6), -BODY_SIZE*sin(PI/6));

void arrowBody(PVector pos, PVector vel, float body_size /*,ColorMode = "RGB"*/){
    float rotate = vel.heading(); 
    float angle = rotate*180/PI;
    
    
    //HSBで群れを視覚的に分類する時に使用。
    if(true){
      colorMode(HSB, 360, 100, 100);
      float hue = map(angle, -180, 180, 0, 360);
      fill(hue, 40, 100);
    }
    
    /*
    //座標系を変換
    pushMatrix();
    //translate(pos.x, pos.y);
    rotate(rotate);
    
    //描画
    noStroke();
    triangle(body_size, 0, -body_size*cos(PI/6), body_size*sin(PI/6), -body_size*cos(PI/6), -body_size*sin(PI/6));
    
    //座標系とカラーモードを通常の状態へ戻す
    colorMode(RGB, 256);
    rotate(-rotate);
    popMatrix();
    */
    
    // 頂点の計算（PShapeTrace用）
    PVector v1 = my_translate(my_rotate(vertex1, rotate), pos);
    PVector v2 = my_translate(my_rotate(vertex2, rotate), pos);
    PVector v3 = my_translate(my_rotate(vertex3, rotate), pos);
    
    noStroke();
    triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
}
