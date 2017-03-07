//
//  DynamictorViewController.swift
//  GrainEffectDemo
//
//  Created by Yioks-Mac on 17/3/7.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

import UIKit

class DynamictorViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var squareView:UIView?;
    var animator : UIDynamicAnimator?;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.squareView = UIView.init(frame: CGRect.init(x: 100, y: 200, width: 50, height: 50));
        self.squareView?.backgroundColor = UIColor.orange;
        self.view.addSubview(self.squareView!);
        self.animator = UIDynamicAnimator.init(referenceView: self.view);
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        /*//重力动画
        let gravity = UIGravityBehavior.init(items: [self.squareView!]);
        gravity.gravityDirection = CGVector.init(dx: 0, dy: 1);
        self.animator?.addBehavior(gravity);
        */
        //碰撞动画
        let collision = UICollisionBehavior.init(items: [self.squareView!]);
        collision.translatesReferenceBoundsIntoBoundary = true;
        collision.collisionMode = UICollisionBehaviorMode.everything;
        collision.collisionDelegate = self;
        self.animator?.addBehavior(collision);
        //collision.addBoundary(withIdentifier: NSCopying, from: CGPoint, to: CGPoint)
        //collision.addBoundary(withIdentifier: NSCopying, for: UIBezierPath)
        
        /*吸附动画
        let attachment = UIAttachmentBehavior.init(item: self.squareView!, attachedToAnchor: (self.squareView?.center)!);
        attachment.length = 50;
        attachment.damping = 0.5;
        attachment.frequency = 1;
        self.animator?.addBehavior(attachment);
        */
        
        //物体属性
        let itemBehavior = UIDynamicItemBehavior.init(items: [self.squareView!]);
        itemBehavior.elasticity = 0.8;
        itemBehavior.allowsRotation = true;
        itemBehavior.addAngularVelocity(1, for: self.squareView!);
        self.animator?.addBehavior(itemBehavior);
        
        let viewTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapViewHandler(_:)));
        self.view.addGestureRecognizer(viewTapGesture);
        
        let snap = UISnapBehavior.init(item: self.squareView!, snapTo: CGPoint.init(x: 100, y: 100));
        self.animator?.addBehavior(snap);
        
    }
    
    func tapViewHandler(_ tap:UITapGestureRecognizer) {
        
        let push = UIPushBehavior.init(items: [self.squareView!], mode: UIPushBehaviorMode.instantaneous);
        let location = tap.location(in: self.view);
        let itemCenter = self.squareView?.center;
        push.pushDirection = CGVector.init(dx: (location.x - itemCenter!.x) / 100, dy: (location.y - itemCenter!.y) / 100);
        self.animator?.addBehavior(push);
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        self.squareView?.backgroundColor = UIColor.init(red: CGFloat(Int(arc4random()) % 256), green: CGFloat(Int(arc4random()) % 256), blue: CGFloat(Int(arc4random()) % 256), alpha: 1);
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        self.squareView?.backgroundColor = UIColor.init(red: CGFloat(Int(arc4random()) % 256), green: CGFloat(Int(arc4random()) % 256), blue: CGFloat(Int(arc4random()) % 256), alpha: 1);
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
