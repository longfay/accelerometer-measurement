//
//  ViewController.swift
//  accelerometer
//
//  Created by 龙菲 on 16/3/14.
//  Copyright © 2016年 Fay. All rights reserved.
//

import UIKit
import CoreMotion //传感器的使用，引入库 CoreMotion


class ViewController: UIViewController, UIAccelerometerDelegate {

    @IBOutlet weak var xLabel: UITextField!

    @IBOutlet weak var yLabel: UITextField!
    
    @IBOutlet weak var zLabel: UITextField!

    var ball: UIImageView!

    var speedX: UIAccelerationValue = 0
    var speedY: UIAccelerationValue = 0
    
    var cmm = CMMotionManager()  //创建类：CMMorionManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any addtional setup after loading the view, typically from a nib.
      //  cmm = CMMotionManager()  //创建实例



        ball = UIImageView(image: UIImage(named:"ball"))
        ball.frame = CGRectMake(0,0,120,120)
        ball.center = self.view.center
        self.view.addSubview(ball) //放一个小球在中央
        
    //}
    
//    func StartAccerometer(){
    
        cmm.accelerometerUpdateInterval = 1/30 //获取频率，每1/30秒获取一次
        if cmm.accelerometerAvailable && !cmm.accelerometerActive{ //判断传感器是否为可用？且没活动
            
            let queue = NSOperationQueue.currentQueue()
        
            cmm.startAccelerometerUpdatesToQueue(queue!, withHandler: {(data:CMAccelerometerData?,err:NSError?) in  //传入加速度传感器数据
            
                print("加速度：(\(data!.acceleration.x),\(data!.acceleration.y),\(data!.acceleration.z))")  //打印加速度数据
                self.xLabel.text = NSString(format: "X: %.6lf g", data!.acceleration.x) as String
                self.yLabel.text = NSString(format: "Y: %.6lf g", data!.acceleration.y) as String
                self.zLabel.text = NSString(format: "Z: %.6lf g", data!.acceleration.z) as String//小数点后六位long float
              //  print("x加速度：\(data!.acceleration.x)")
              //  print("\(self.ball.center)")

                
                self.speedX += data!.acceleration.x
                self.speedY += data!.acceleration.y
                var posX = self.ball.center.x + CGFloat(self.speedX)
                var posY = self.ball.center.y - CGFloat(self.speedY) //动态设置小球位置
                    //print("\(CGPointMake(posX,posY))")
                
                
                if posX < 0{    //碰到边框后的反弹处理
                    posX = 0
                    self.speedX *= -0.4 //碰到左边边框后以0.4倍的速度反弹
                }else if posX > self.view.bounds.size.width{
                    posX = self.view.bounds.size.width
                    self.speedX *= -0.4 //碰到右边的边框后以0.4倍的速度反弹
                }
                
                if posY < 0{
                    posY=0
                    self.speedY=0   //碰到上面的边框不反弹
                }else if posY > self.view.bounds.size.height{
                    posY = self.view.bounds.size.height
                    self.speedY *= -1.5 //碰到下面的边框以1.5倍的速度反弹
                }
                self.ball.center = CGPointMake(posX,posY)
               // print("\(CGPointMake(posX,posY))")

            })
        }else{
                print("加速度传感器不可用")
            }
        
   }
    
    func StopAcceler(){
        if cmm.accelerometerActive{ //如果加速器传感器还在活动
            cmm.stopAccelerometerUpdates()  //停止侦听加速器传感器
        }
    }
    
 //   override func viewDidAppear(animated: Bool) {   //view呈现出来的时候启动
 //       StartAccerometer()
  
   // }
    

    
    override func viewWillDisappear(animated: Bool) {   //程序界面消失
        StopAcceler()
    }  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
