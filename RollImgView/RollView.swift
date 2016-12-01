//
//  RollView.swift
//  RollImgView
//
//  Created by sqluo on 2016/12/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


class RollView: UIView {
    
    fileprivate enum RollDirection {
        case upDown     //上下移动
        case leftRight  //左右移动
    }
    
    //public 可以设置
    
    //滚动的时间间隔,是每次滚动的距离需要的时间，设置越小，移动越快。默认是0.01秒
    public var timeInterval: TimeInterval = 0.01
    //每次滚动的距离 默认为0.5个像素
    public var rollSpace: CGFloat = 0.5

    //滚动的图片
    fileprivate var rollImage: UIImage!
    //滚动图片View
    fileprivate var rollImageView = UIImageView()
    
    
    //滚动方向
    fileprivate var direction = RollDirection.leftRight
    //滚动视图计时器
    fileprivate var rollTimer: Timer?
    
    //是否反向翻滚
    fileprivate var isReverse = false
    //左右偏移
    fileprivate var rollX: CGFloat = 0.0
    //上下偏移
    fileprivate var rollY: CGFloat = 0.0
    

    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.rollImage = image
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func draw(_ rect: CGRect) {

        self.addRollImageAndTimer()
    }
 
    
    fileprivate func addRollImageAndTimer(){
        
        if self.rollImage != nil && (rollImage.size.width / rollImage.size.height < self.frame.width / self.frame.height) && (abs(self.frame.width / rollImage.size.width * rollImage.size.height) - self.frame.height > self.frame.height / 4) {
            //本地图片的宽高比(100*568)<视图的宽高比(320*568) 并且缩放后高度还大于WSRollView高的1/4时，进行上下滚动
            print("上下滚动")
            
            let w = self.frame.width
            let h = self.frame.width / rollImage.size.width * rollImage.size.height
            
            self.rollImageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
            
            self.rollImageView.image = self.rollImage
            
            self.clipsToBounds = true
            
            self.direction = .upDown
            
            self.rollTimer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.rollImageAction), userInfo: nil, repeats: true)
            self.rollTimer?.fire()
   
            
        } else if rollImage != nil && (rollImage.size.width / rollImage.size.height > self.frame.width / self.frame.height) && (abs((self.frame.height / rollImage.size.height) * rollImage.size.width) - self.frame.width > self.frame.width / 4) {
            //本地图片的宽高比(500*568)>视图的宽高比(320*568) 并且缩放后宽度还大于WSRollView宽的1/4时，进行左右滚动
            
            print("左右滚动")
            
            let w = self.frame.height / rollImage.size.height * rollImage.size.width
            let h = self.frame.height
            
            self.rollImageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
            
            self.rollImageView.image = rollImage
            
            self.clipsToBounds = true
            
            self.addSubview(rollImageView)
            
            self.direction = .leftRight
            
            self.rollTimer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.rollImageAction), userInfo: nil, repeats: true)
            self.rollTimer?.fire()
            
        } else {
            
            self.rollImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.rollImageView.image = self.rollImage
            //截掉超过父视图大小的_rollImageView
            self.clipsToBounds = true
            self.addSubview(self.rollImageView)
            print("Error:没有图片或者图片宽高比和视图相同,直接显示不滚动")
        }
   
    }
    
 
    
    
    @objc fileprivate func rollImageAction(){

        switch self.direction {
        case .upDown:
            print("上下")
            
            if (rollY - self.rollSpace > self.frame.height - self.frame.width / rollImage.size.width * rollImage.size.height) && !isReverse {
                
                rollY -= self.rollSpace
                
                let w = self.frame.width
                let h = self.frame.width / rollImage.size.width * rollImage.size.height
                
                self.rollImageView.frame = CGRect(x: 0, y: rollY, width: w, height: h)
                
            }else{
                
                self.isReverse = true
                
            }
            
            if rollY + self.rollSpace < 0 && isReverse {
                
                rollY += self.rollSpace
                
                let w = self.frame.width
                let h = self.frame.width / rollImage.size.width * rollImage.size.height
                self.rollImageView.frame = CGRect(x: 0, y: rollY, width: w, height: h)
                
            }else{
                self.isReverse = false
            }
            
            
        case .leftRight:
            
            if (rollX - self.rollSpace > self.frame.width - self.frame.height / rollImage.size.height * rollImage.size.width) && !isReverse {
                
                rollX -= self.rollSpace
                
                let w = self.frame.height / rollImage.size.height * rollImage.size.width
                let h = self.frame.height
                rollImageView.frame = CGRect(x: rollX, y: 0, width: w, height: h)
                

            }else{
                
                isReverse = true
                
                
            }
            
            
            if rollX + self.rollSpace < 0 && isReverse {
                
                rollX += self.rollSpace
                
                
                let w = self.frame.height / rollImage.size.height * rollImage.size.width
                let h = self.frame.height
                
                rollImageView.frame = CGRect(x: rollX, y: 0, width: w, height: h)
                
                
            }else{
                isReverse = false
                
            }
            


        }
        
        
        
    }
    
    
    
    
    deinit {
        print(".....释放")
        self.rollTimer?.invalidate()
        self.rollTimer = nil
    }
    
    
  
    

}
