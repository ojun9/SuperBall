//
//  Timer.swift
//  SuperBall
//
//  Created by jun on 2018/12/28.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation
import SpriteKit

class GameTimer {

   var TimerLabel: SKLabelNode = SKLabelNode(text: String(0))
   var TimeInterVal = 0.1
   var TimeCount : Float = 0// 時間計測用の変数.
   var MyTimer = Timer()
   var PauseTime:Float = 0 // 一時停止の際の時間を格納する
   
   init() {
      TimerLabel.fontSize = 100
   }
   
   public func InitTimer(ViewX: Int, ViewY: Int) {
      let Wide = ViewX / 2 + ViewX / 5
      let Hight = ViewY / 3
      
      let Intarnal = ViewX / 25
      let FirstZure = -ViewX * 2 / 5   //位置ズレ防止
      
      let TimerLabelPositionX = FirstZure + Intarnal  + Wide
      let TimerLabelPositionY = Hight
      
      TimerLabel.position = CGPoint(x: TimerLabelPositionX, y: TimerLabelPositionY)
   }
   
   public func StartTimer(){
      self.MyTimer = Timer.scheduledTimer(timeInterval: TimeInterVal, target: self, selector: #selector(GameTimer.TimerUpdate(timer:)), userInfo: nil, repeats: true)
   }
   
   public func StopTimer() -> Float{
      self.MyTimer.invalidate()
      return TimeCount
   }
   
   // TimerのtimeIntervalで指定された秒数毎に呼び出されるメソッド
   @objc func TimerUpdate(timer : Timer){
            // カウントの値1増加
      TimeCount += Float(TimeInterVal)
      
      // 桁数を指定して文字列を作る
      let str = String(format: "%.f", TimeCount)
      
      // ラベルに表示
      self.TimerLabel.text = str
      
   }
   
}
