//
//  ViewController.swift
//  GameCenterTestProject
//
//  Created by Satoru Ohguchi on 2016/03/09.
//  Copyright © 2016年 maripara.org. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController,GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GameCenterログオン
    @IBAction func GameCenterLogon(sender: AnyObject) {
        // ログイン画面
    }

    // GameCenter
    @IBAction func clickShow(sender: AnyObject) {
        let game = GKGameCenterViewController()
        game.gameCenterDelegate = self
        self.presentViewController(game, animated: true, completion: nil)
    }
    
    /// GameCenter を閉じる
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
            dismissViewControllerAnimated(true, completion: nil)
    }
}
