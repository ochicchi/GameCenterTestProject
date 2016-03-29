//
//  ViewController.swift
//  GameCenterTestProject
//
//  Created by Satoru Ohguchi on 2016/03/09.
//  Copyright © 2016年 maripara.org. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController,GKGameCenterControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var text1: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        text1.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GameCenterログオン
    @IBAction func GameCenterLogon(sender: AnyObject) {
        // ログイン画面
//        let player = GKLocalPlayer()
//        player.authenticateHandler = {
//            (uc, err) in
//            if player.authenticated == true {
//                // ローカルプレイヤーの認証後
//                self.label1.text = "ゲームセンターにログイン済み"
//            } else {
//                // ゲームセンターにログインしていない
//                self.label1.text = "ゲームセンターにログインしてください"
//            }
//        }
    }

    // GameCenter を表示する。(リーダーズボード)
    @IBAction func clickShow(sender: AnyObject) {
        let game = GKGameCenterViewController()
        game.gameCenterDelegate = self
        self.presentViewController(game, animated: true, completion: nil)
        game.viewState = GKGameCenterViewControllerState.Leaderboards
        self.label1.text = "GameCenter表示中"
    }
    
    // GameCenter を閉じる
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
            dismissViewControllerAnimated(true, completion: nil)
            self.label1.text = "GameCenter表示終了"
    }

    // テキストの入力制御(リターンを押したらキーボードクローズ)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // GameCenterにベストスコア/最新スコアを送信
    @IBAction func ScoreUpdate(sender: AnyObject) {
        let score = Int.init(text1.text!)
        let newScore = GKScore(leaderboardIdentifier: "testNewScore")
        
        newScore.value = Int64(score!)
        newScore.context = 0            // おまじない
        
        let bestScore = GKScore(leaderboardIdentifier: "testBestScore")
        
        bestScore.value = Int64(score!)
        bestScore.context = 0
        
        let scores = [ newScore, bestScore ]
        
        GKScore.reportScores(scores, withCompletionHandler: {(error) in
            if (error != nil) {
                self.label1.text = "GameCenterスコア送信エラー"
            }else{
                self.label1.text = "GameCenterスコア送信完了"
            }
        });
    }
    
    // ランキングを調査する
    @IBAction func clickRankingCheck(sender: AnyObject) {
        // 変数初期化
        var localUserRank:Int = 999
        
        // 呼び出し時の条件指定
        let leaderboard = GKLeaderboard()
        
        leaderboard.identifier  = "testBestScore"
        leaderboard.playerScope = GKLeaderboardPlayerScope.Global
        leaderboard.timeScope   = GKLeaderboardTimeScope.AllTime
        leaderboard.range       = NSRange(location: 1,length: 10)
        
        let localUser = GKLocalPlayer.localPlayer().alias! as String
        print("\(localUser)")
        
        // ゲームセンターデータ読み取り
        leaderboard.loadScoresWithCompletionHandler { (scores, error) -> Void in
            if (error == nil) {
                // 取得したデータでループ
                for score in scores! as [GKScore] {
                    let scorePlayerUser = score.player.alias! as String
                    // 自分のランキングを検索
                    if (localUser == scorePlayerUser) {
                        localUserRank = score.rank
                    }
                }
                self.label1.text = "BestScore順位 = \(localUserRank)"
            } else {
                self.label1.text = "取得できませんでした"
            }
        }
        // print("順位 = \(localUserRank)")
    }
    
    /// 達成項目を更新する
    @IBAction func clickAchievement(sender: AnyObject) {
        
        // Achievementの値をセット
        let achievement = GKAchievement(identifier: "testFirstPlay")
        achievement.percentComplete = 100.0 // 達成

        // Achievementを送信
        GKAchievement.reportAchievements([achievement], withCompletionHandler: {(error) in
            if (error != nil) {
                self.label1.text = "GameCenterAchievements送信エラー"
            }else{
                self.label1.text = "GameCenterAchievements送信完了"
            }
        })
    }

    /// 達成項目を表示する
    @IBAction func clickAchievementShow(sender: AnyObject) {
        let game =  GKGameCenterViewController()
        game.gameCenterDelegate = self
        game.viewState = GKGameCenterViewControllerState.Achievements
        self.presentViewController(game, animated: true, completion: nil)
    }
    
    /// 達成度を取得する
    @IBAction func clickAchievementGet(sender: AnyObject) {
        GKAchievement.loadAchievementsWithCompletionHandler({
            (achievements, err) -> Void in
            // if achievements != nil {
            if achievements!.count > 0  {
                for achievement in achievements! {
                    if achievement.identifier == "testFirstPlay" {
                        self.label1.text = "達成度 \(achievement.percentComplete)"
                    }
                }
            }
        })
    }
    
    /// 達成度をリセットする
    @IBAction func clickAchievementReset(sender: AnyObject) {
        GKAchievement.resetAchievementsWithCompletionHandler({
            (err) in
            // リセット後の処理
            let alert = UIAlertController(title: "Achievements",
                message: "達成項目をリセットしました",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(
                UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil ))
            self.presentViewController(alert, animated: true, completion: nil )
        })
    }

}
