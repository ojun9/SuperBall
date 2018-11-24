//
//  Ball.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Animo


class ball :SKSpriteNode {
   
   public let SelfNumber: Int
   private var Movement:Int
   public var PositionX: Int
   public var PositionY: Int
   private let AnimateioSpeed = 0.22
   
   public var TouchBegan: CGPoint
   private var AreYouMoved: Bool = true
   private var AreYouLarge: Bool = false
   
   private var AfterMovedPointX: CGFloat
   private var AfterMovedPointY: CGFloat
 
   init(BallPositionX: Int, BallPositionY: Int, BallColor: Int, ViewX: Int, ViewY: Int) {
      
      
      let Wide = ViewX / 5
      let Intarnal = ViewX / 25
      let FirstZure = -ViewX * 2 / 5
      let x1 = FirstZure + Intarnal * BallPositionX + Wide * (BallPositionX - 1)
      let y1 = -ViewY * 3 / 8 + Intarnal * BallPositionY + Wide * (BallPositionY - 1)
      
      let texture: SKTexture
      
      self.PositionX = BallPositionX
      self.PositionY = BallPositionY
      self.Movement = Wide + Intarnal
      self.TouchBegan = CGPoint(x: 0, y: 0)
      
      self.AfterMovedPointX = x1
      self.AfterMovedPointY = y1
      
      switch BallColor {
      case 1:
         texture = SKTexture(imageNamed: "One.png")
         self.SelfNumber = BallColor
         break
      case 2:
         texture = SKTexture(imageNamed: "Two.png")
         self.SelfNumber = BallColor
         break
      case 3:
         texture = SKTexture(imageNamed: "Three.png")
         self.SelfNumber = BallColor
         break
      case 4:
         texture = SKTexture(imageNamed: "Four.png")
         self.SelfNumber = BallColor
         break
      case 5:
         texture = SKTexture(imageNamed: "Five.png")
         self.SelfNumber = BallColor
         break
      default:
         print("BallNumber is \(BallColor)")
         fatalError("BallNumber is NOT 1...4")
         break;
      }
      
      super.init(texture: texture, color: UIColor.cyan, size: CGSize(width: CGFloat(ViewX / 5), height: CGFloat(ViewX / 5)))
      
      self.isUserInteractionEnabled = true

      
      self.position = CGPoint(x: x1, y: y1)

      
      //PositionY = y
      //position = CGPoint(node.position.x, node.position.y + 10)
      //self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(10, 10))
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func ShowData() {
      print("Ball.position = \(self.position)")
      print("Ball.size = \(self.size)")
      print("Ball.selfNUM = \(self.SelfNumber)")
      print("Ball.PositionX = \(self.PositionX)")
      print("Ball.position = \(self.position)")

   }
   
   private func WhereSwip(X: CGFloat, Y: CGFloat) -> Int {
     
      var degree:Int
      
      if(X != 0){
         let radian = atan(Y/abs(X)) //arctan からラジアンを求める
         degree = Int(radian * CGFloat(180 * M_1_PI)) //ラジアンから角度に変換
      }else{
         // x方向の変化がなかった場合(=垂直方向にスワイプされた場合)
         degree = Y < 0 ? -90:90;
      }
      print("角度は \(degree)")
      return degree
   }
   
   private func PostNotification(Vect: String){
      
      let SentObject: [String : Any] = ["SentX": self.PositionX as Int,
                                        "SentY": self.PositionY as Int,
                                        "Vect": Vect as String]
      
      print("")
      NotificationCenter.default.post(name: .notifyName, object: nil, userInfo: SentObject)
   }
   
   private func SwipCheck(x: CGFloat, y: CGFloat) {
      
      switch WhereSwip(X: x, Y: y) {
      case -90 ..< -45:
         print("下にスワイプされたよ")
         PostNotification(Vect: "Down")
      case -45 ..< 45:
         if(x >= 0){
            print("右にスワイプされたよ")
            PostNotification(Vect: "Right")
         }else{
            print("左にスワイプされたよ")
            PostNotification(Vect: "Left")
         }
      case 45 ... 90:
         print("上にスワイプされたよ")
         PostNotification(Vect: "Up")
      default:
         print("上にスワイプされたよ(default)")
         PostNotification(Vect: "Up")
      }
      
      print()
      return
  
   }
   
   private func LargeAnimation() {
      
      if self.AreYouLarge == false {
         let Large: SKAction = SKAction.scale(by: 1.2, duration: 0.2)
         self.run(Large)
         self.AreYouLarge = true
         return
      }
   }
   
   private func SmallAnimateion() {
      
      if self.AreYouLarge == true {
         let Small: SKAction = SKAction.scale(by: 1 / 1.2, duration: 0.2)
         self.run(Small)
         self.AreYouLarge = false
         return
      }
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

      print("AreYouMoved = \(self.AreYouMoved)")
      
      guard self.AreYouMoved == true else {
         print("移動中です。(StartPoint)")
         return
      }
      
      
      print("--- ball info ---")
      print("ball num is \(self.SelfNumber)")
      print("ball posi is [\(self.PositionX)][\(self.PositionY)]")
      
      
      
      
      if let TouchStartPoint = touches.first?.location(in: self) {
         self.TouchBegan = TouchStartPoint
         print("touch Start Point = \(self.TouchBegan)")
         LargeAnimation()
      }else{
         print("タッチ離したとき、Nilでした。")
      }
      
      return
   }
   
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
      guard self.AreYouMoved == true else {
         print("移動中です。(EndPoint)")
         return
      }
      
      self.AreYouMoved = false
      
      if let TouchEndPoint = touches.first?.location(in: self) {
         var TmpPoint = TouchEndPoint
         TmpPoint.x = TmpPoint.x - self.TouchBegan.x
         TmpPoint.y = TmpPoint.y - self.TouchBegan.y
         print("touch End Point = \(TouchEndPoint)")
         SmallAnimateion()
         if LengthOfTwoPoint(Start: TouchBegan, End: TouchEndPoint) == false {
            print("移動はしません")
            self.AbleToMove()
            return
         }
         SwipCheck(x: TmpPoint.x, y: TmpPoint.y)
         return
      }else{
         print("タッチ離したあと、Nilでした。")
         return
      }
      
      
   }
   
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     // print("ballタッチが動いてる")
   }
   
   public func ChangeColor() {
      self.color = UIColor.blue
   }
   
   private func AfterMoveInfo(First: Bool) {
      
      if First == true {
         print("Firstの位置情報")
         print("First[\(self.PositionX)][\(self.PositionY)]")
      }else{
         print("Secondの位置情報")
         print("Second[\(self.PositionX)][\(self.PositionY)]")
      }
      print("")
      return
      
   }
   
   public func MoveUp(MoveX: Int, MoveY: Int, First: Bool) {
      
      self.AreYouMoved = false
      self.PositionY += 1
      
      let MovePoint = CGPoint(x: self.position.x, y: self.position.y + CGFloat(Movement))
      let Aktion: SKAction = SKAction.move(to: MovePoint, duration: AnimateioSpeed)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove()
      }) ])
      self.run(action)
      
      AfterMoveInfo(First: First)

   }
   
   public func MoveDown(MoveX: Int, MoveY: Int, First: Bool){
      
      self.AreYouMoved = false
      self.PositionY -= 1
      
      let MovePoint = CGPoint(x: self.position.x, y: self.position.y - CGFloat(Movement))
      let Aktion: SKAction = SKAction.move(to: MovePoint, duration: AnimateioSpeed)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove()
      }) ])
      self.run(action)
      
      AfterMoveInfo(First: First)

   }
   
   public func MoveRight(MoveX: Int, MoveY: Int, First: Bool) {
      
      self.AreYouMoved = false
      self.PositionX += 1
      
      let MovePoint = CGPoint(x: self.position.x + CGFloat(Movement), y: self.position.y)
      let Aktion: SKAction = SKAction.move(to: MovePoint, duration: AnimateioSpeed)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove()
      }) ])
      self.run(action)
      AfterMoveInfo(First: First)
   }
   
   public func MoveLeft(MoveX: Int, MoveY: Int, First: Bool) {
      
      self.AreYouMoved = false
      self.PositionX -= 1
      
      let MovePoint = CGPoint(x: self.position.x - CGFloat(Movement), y: self.position.y)
      let Aktion: SKAction = SKAction.move(to: MovePoint, duration: AnimateioSpeed)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove()
      }) ])
      self.run(action)
      AfterMoveInfo(First: First)
   }
   
   public func AbleToMove(){
      print("動けるようになりました。")
      self.AreYouMoved = true
      return
   }
   
   private func LengthOfTwoPoint(Start: CGPoint, End: CGPoint) -> Bool {
   
      let xDistance = Start.x - End.x
      let yDistance = Start.y - End.y
      let distance = sqrtf(Float(xDistance*xDistance + yDistance*yDistance))
      
      print("2点間の距離は\(distance)")
      
      if distance < 55 {
         return false
      }
      
      return true
   }
   
}
