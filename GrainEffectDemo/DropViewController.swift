//
//  DropViewController.swift
//  GrainEffectDemo
//
//  Created by Yioks-Mac on 17/3/3.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

import UIKit
import CoreMotion
import CoreFoundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height - 64;

class DropViewController: UIViewController {
    
    let motionManager : CMMotionManager = CMMotionManager.init();
    
    var gravityBehavior:UIGravityBehavior = UIGravityBehavior.init();
    
    lazy var animator:UIDynamicAnimator = {
        () -> UIDynamicAnimator in
        var a = UIDynamicAnimator.init(referenceView: self.giftView!);
        return a;
    }()
    var collisionBehavitor:UICollisionBehavior?;
    var itemBehavitor:UIDynamicItemBehavior?;
    var dropsArray:[Any]?;
    var leftShoot:UIImageView?;
    var rightShoot:UIImageView?;
    var giftView:UIView?;
    var timer:DispatchSourceTimer?;
    var isDropping:Bool = false;
    var page:Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        
        self.animator = UIDynamicAnimator.init(referenceView: self.giftView!);
        self.gravityBehavior = UIGravityBehavior.init();
        self.collisionBehavitor = UICollisionBehavior.init();
        self.collisionBehavitor?.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsetsMake(0, 0, 0, 0));
        self.animator.addBehavior(self.gravityBehavior);
        self.animator.addBehavior(self.collisionBehavitor!);
        
        startMotion();
        
        setUp();
        
    }
    
    func setUp() {
        giftView = UIView.init(frame:CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT));
        self.view.addSubview(giftView!);
        leftShoot = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20));
        leftShoot?.image = #imageLiteral(resourceName: "leftShoot.png");
        self.giftView?.addSubview(leftShoot!);
        leftShoot?.center = CGPoint.init(x: 50, y: 100);
        
        rightShoot = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20));
        rightShoot?.image = #imageLiteral(resourceName: "rightShoot.png");
        self.giftView?.addSubview(rightShoot!);
        rightShoot?.center = CGPoint.init(x: SCREEN_WIDTH - 50, y: 100);
        
        let button :UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 80, width: 50, height: 30));
        button.backgroundColor = UIColor.gray;
        button.setTitle("开始", for: UIControlState.normal);
        self.view.addSubview(button);
        button.addTarget(self, action:#selector(addSerialDrop), for: UIControlEvents.touchUpInside);
        
        let clearButton = UIButton.init(frame: CGRect.init(x: 200, y: 80, width: 50, height: 30));
        clearButton.backgroundColor = UIColor.gray;
        clearButton.setTitle("清除", for: UIControlState.normal);
        self.view.addSubview(clearButton);
        clearButton .addTarget(self, action: #selector(didClickedClear(_:)), for: UIControlEvents.touchUpInside);
        
        
    }
    
    func test() {
        
    }
    
    func test1(a : String, b: String) -> String {
        return "";
    }
    
    func test2(a: Int, b: Int) -> String {
        return "";
    }
    
    func addSerialDrop(_ btn:UIButton) {
        self.startMotion();
        let love :UIImage = #imageLiteral(resourceName: "love.png");
        let star :UIImage = #imageLiteral(resourceName: "star.png");
        if (self.dropsArray?.count)! % 2 == 0 {
            self.drop(count: 30, images: [love]);
        }else {
            self.drop(count: 30, images: [star]);
        }
        self.serialDrop();
    }
    
    func serialDrop() {
        if isDropping {
            return;
        }
        isDropping = true;
        var queue:DispatchQueue = DispatchQueue.main;
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: queue);
        var start = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC)));
        var interval:UInt64 = UInt64(0.05 * Double( NSEC_PER_SEC));
        self.timer?.scheduleRepeating(deadline: start, interval: DispatchTimeInterval.seconds(Int(interval)), leeway: DispatchTimeInterval.seconds(0));
        self.timer?.setEventHandler(handler: DispatchWorkItem.init(block: {
            if self.dropsArray?.count == 0 {
                return ;
            }
            var currentDrops:[Any] = self.dropsArray?[0] as! [Any];
            if currentDrops.count > 0 {
                var dropView:UIImageView = currentDrops[0] as! UIImageView;
                currentDrops.remove(at: 0);
                self.giftView?.addSubview(dropView);
                var pushBehavior = UIPushBehavior.init(items: [dropView], mode: UIPushBehaviorMode.instantaneous);
            }
        }));
        
        
    }
    
    func drop(count:Int, images:[UIImage]) -> Array<Any> {
        var viewArray:[UIImageView] = Array();
        for i in 0...count {
            let image:UIImage = images[Int(arc4random()) % images.count];
            let imageView:UIImageView = UIImageView.init(image: image);
            imageView.contentMode = UIViewContentMode.center;
            imageView.center = CGPoint.init(x: 50, y: 100);
            imageView.tag = 11;
            if i % 2 == 0 {
                imageView.center = CGPoint.init(x: SCREEN_WIDTH - 50, y: 100);
                imageView.tag = 22;
            }
            viewArray.append(imageView);
        }
        self.dropsArray?.append(viewArray);
        return dropsArray!;
    }
    
    func didClickedClear(_ btn:UIButton) {
        
    }
    
    func startMotion() {
        if motionManager.isAccelerometerAvailable {
            if !motionManager.isAccelerometerActive {
                motionManager.accelerometerUpdateInterval = 1.0 / 3.0;
                [motionManager .startAccelerometerUpdates(to: OperationQueue.init(), withHandler: { [weak self](accelerometerData :CMAccelerometerData?, error:Error?) in
                    
                    if let e = error {
                        print("coremotion error \(e)");
                        self?.motionManager.stopAccelerometerUpdates();
                    }
                    
                    let a:Double = (accelerometerData?.acceleration.x)!;
                    let b:Double = (accelerometerData?.acceleration.y)!;
                    
                    let gravityDirection = CGVector.init(dx: a, dy: -b);
                    
                    self?.gravityBehavior.gravityDirection = gravityDirection;
                    
                })];
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
