//
//  GameViewController.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

import UIKit
import SpriteKit
import Social

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notification window interface
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameOver", name: "GAME_OVER", object: nil)

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
                       
        }
    }
    
    /*
    * Using notification to pop game over window
    */
    func gameOver() {
        
        var shareMessage = "Air Tartan is an awesome game. Go to App Store now and download!"
        
        let alert = UIAlertController(title: "Game Over", message: "New game?", preferredStyle: UIAlertControllerStyle.Alert)
        let newGameAction = UIAlertAction(title: "New game", style: UIAlertActionStyle.Default, handler: nil)
        let shareFacebook = UIAlertAction(title: "Post Facebook", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
            self.shareToSocial(SLServiceTypeFacebook, message: shareMessage)
        })
        let shareTwitter = UIAlertAction(title: "Tweets", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
            self.shareToSocial(SLServiceTypeTwitter, message: shareMessage)
        })
        
        alert.addAction(newGameAction)
        alert.addAction(shareFacebook)
        alert.addAction(shareTwitter)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    *   Using SLComposeViewController integrated with facebook and twitter
    */
    func shareToSocial(platform:String, message: String) {
        
        if(platform == SLServiceTypeFacebook) {
            
            var fbSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet.setInitialText(message)
            
            self.presentViewController(fbSheet, animated: true, completion: nil)
            
        }else if (platform == SLServiceTypeTwitter) {
            
            var tweetSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet.setInitialText(message)
            
            self.presentViewController(tweetSheet, animated: true, completion: nil)
            
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
