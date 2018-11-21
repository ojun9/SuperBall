//
//  Stage.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation
import UIKit

class HoldStage {

   
   public var Stage = [[-1, -1, -1, -1, -1, -1],
                        [-1, -1, -1, -1, -1, -1],
                        [-1, -1, -1, -1, -1, -1],
                        [-1, -1, -1, -1, -1, -1],
                        [-1, -1, -1, -1, -1, -1],
                        [-1, -1, -1, -1, -1, -1],]
   
   private let StageFlame: Int
   private var Referee = referee(Num: 0, Count: 0)
   public var ViewSizeX : CGFloat = 0
   public var ViewSizeY : CGFloat = 0
   
   
   
   init(Flame: Int) {
      self.StageFlame = Flame
      SetStageNum()
      //SetStageBall()
   }
   
   public func SetStageSizeX(SizeX: CGFloat){
      self.ViewSizeX = SizeX
      print("ビューの横幅：\(self.ViewSizeX)")
      return
   }
   
   public func SetStageSizeY(SizeY: CGFloat){
      self.ViewSizeY = SizeY
      print("ビューの縦幅：\(self.ViewSizeY)")
      return
   }
   
//   private func SetStageBall() {
//      for x in 1 ... 4 {
//         for y in 1 ... 4 {
//            let StageNum: Int = self.Stage[x][y]
//            let Ball = ball(BallPositionX: x, BallPositionY: y, BallColor: StageNum)
//            Ball.name = "\(x)+\(y)"
//         }
//      }
//   }
   
   public func SetStageNum() {
      for x in 1 ... 4 {
         for y in 1 ... 4 {
            let RandNum: Int = Int(arc4random_uniform(5) + 1)
            self.Stage[x][y] = RandNum
         }
      }
      print("ステージを初期化しました。")
      print("---Stage情報---")
      print("[")
      for x in 1 ... 4 {
         print("[ ", terminator: "")
         for y in 1 ... 4 {
            print("\(self.Stage[x][y]) " , terminator: "")
         }
         print("]")
      }
      print("]")
   }
   
   
   /// ある座標について、その上下左右に同じ数字があるか判定
   ///
   /// - Parameters:
   ///   - x: x座標
   ///   - y: y座標
   /// - Returns: 存在すればTrueを返す。
   public func CheckStage(x: Int, y: Int) -> Bool {
      Referee.CheckedNum = self.Stage[x][y]
      print("ステージの[\(x)][\(y)] = \(Referee.CheckedNum)を確認します。")
      
      // 上を確認
      if self.Stage[x][y - 1] == Referee.CheckedNum {
         print("上が一致")
         self.Referee.CountOfBall += 1
      }
      
      // 下を確認
      if self.Stage[x][y + 1] == Referee.CheckedNum {
         print("下が一致")
         self.Referee.CountOfBall += 1
      }
      
      // 右を確認
      if self.Stage[x + 1][y] == Referee.CheckedNum {
         print("右が一致")
         self.Referee.CountOfBall += 1
      }
      
      // 左を確認
      if self.Stage[x - 1][y] == Referee.CheckedNum {
         print("左が一致")
         self.Referee.CountOfBall += 1
      }
      
      if self.Referee.CountOfBall > 0 {
         return true
      }
      print("一致するものはありませんでした。")
      return false
   }
   
   public func SwapArryPosition(x1: Int, y1: Int, x2: Int, y2: Int){
      print("変更前：")
      print("stage[\(x1)][\(y1)] = \(self.Stage[x1][y1])")
      print("stage[\(x2)][\(y2)] = \(self.Stage[x2][y2])")
      let tmp = self.Stage[x1][y1]
      self.Stage[x1][y1] = self.Stage[x2][y2]
      self.Stage[x2][y2] = tmp
      print("変更後：")
      print("stage[\(x1)][\(y1)] = \(self.Stage[x1][y1])")
      print("stage[\(x2)][\(y2)] = \(self.Stage[x2][y2])")
      return
      
   }
}
