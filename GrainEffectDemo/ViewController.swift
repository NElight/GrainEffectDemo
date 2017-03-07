//
//  ViewController.swift
//  GrainEffectDemo
//
//  Created by Yioks-Mac on 17/3/3.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableview : UITableView = UITableView();
    lazy var dataList : [String] = ["粒子掉落","直播礼物冒泡效果","烟花效果","喷射效果","雪花飘落", "222222"];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUp();
    }
    
    func setUp() {
        tableview = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain);
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = UIView.init();
        self.view.addSubview(self.tableview);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: "cell");
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell");
        }
        
        cell?.textLabel?.text = dataList[indexPath.row];
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview .deselectRow(at: indexPath, animated: true);
        switch indexPath.row {
        case 0:
            let vc:DropViewController = DropViewController();
            self.navigationController?.pushViewController(vc, animated: true);
            
        case 5:
            let vc:DynamictorViewController = DynamictorViewController();
            self.navigationController?.pushViewController(vc, animated: true);
            
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

