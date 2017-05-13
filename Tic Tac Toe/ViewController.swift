//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Vignan Sankati on 5/12/17.
//  Copyright © 2017 Vignan Sankati. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController,MCBrowserViewControllerDelegate {
    
    var appDelegate:AppDelegate!
    var currentPlayer:String!
    @IBOutlet var playerInputs: [PlayerInputImageView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.multipeerConnectivityHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.multipeerConnectivityHandler.setupSession()
        appDelegate.multipeerConnectivityHandler.advertiseSetup(advertise: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peerStateChangedNotification), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedDataWithNotification), name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil)
        
        gameSetup()
        currentPlayer = "x"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connect(_ sender: Any) {
        if appDelegate.multipeerConnectivityHandler.session != nil {
            appDelegate.multipeerConnectivityHandler.setupBrowser()
            appDelegate.multipeerConnectivityHandler.browser.delegate = self
            
            self.present(appDelegate.multipeerConnectivityHandler.browser, animated: true, completion: nil)
        }
    }
    
    @IBAction func newGame(_ sender: Any) {
        gameReset()
        
        let messageDict = ["message":"New Game"]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
            try appDelegate.multipeerConnectivityHandler.session.send(messageData, toPeers: appDelegate.multipeerConnectivityHandler.session.connectedPeers, with: .reliable)
        }
        catch _ {
            print("Error in new game")
        }
        
        
    }

    func gameSetup() {
        for index in 0 ... playerInputs.count-1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(inputTapped))
            gestureRecognizer.numberOfTapsRequired = 1
            
            playerInputs[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func gameReset() {
        for index in 0 ... playerInputs.count-1 {
            playerInputs[index].image = nil
            playerInputs[index].activated = false
            playerInputs[index].player = ""
        }
        currentPlayer = "x"
    }
    
    func checkResult() {
        var winner = ""
        
        if playerInputs[0].player == "x" && playerInputs[1].player == "x" && playerInputs[2].player == "x"{
            winner = "x"
        }else if playerInputs[0].player == "o" && playerInputs[1].player == "o" && playerInputs[2].player == "o"{
            winner = "o"
        }else if playerInputs[3].player == "x" && playerInputs[4].player == "x" && playerInputs[5].player == "x"{
            winner = "x"
        }else if playerInputs[3].player == "o" && playerInputs[4].player == "o" && playerInputs[5].player == "o"{
            winner = "o"
        }else if playerInputs[6].player == "x" && playerInputs[7].player == "x" && playerInputs[8].player == "x"{
            winner = "x"
        }else if playerInputs[6].player == "o" && playerInputs[7].player == "o" && playerInputs[8].player == "o"{
            winner = "o"
        }else if playerInputs[0].player == "x" && playerInputs[3].player == "x" && playerInputs[6].player == "x"{
            winner = "x"
        }else if playerInputs[0].player == "o" && playerInputs[3].player == "o" && playerInputs[6].player == "o"{
            winner = "o"
        }else if playerInputs[1].player == "x" && playerInputs[4].player == "x" && playerInputs[7].player == "x"{
            winner = "x"
        }else if playerInputs[1].player == "o" && playerInputs[4].player == "o" && playerInputs[7].player == "o"{
            winner = "o"
        }else if playerInputs[2].player == "x" && playerInputs[5].player == "x" && playerInputs[8].player == "x"{
            winner = "x"
        }else if playerInputs[2].player == "o" && playerInputs[5].player == "o" && playerInputs[8].player == "o"{
            winner = "o"
        }else if playerInputs[0].player == "x" && playerInputs[4].player == "x" && playerInputs[8].player == "x"{
            winner = "x"
        }else if playerInputs[0].player == "o" && playerInputs[4].player == "o" && playerInputs[8].player == "o"{
            winner = "o"
        }else if playerInputs[2].player == "x" && playerInputs[4].player == "x" && playerInputs[6].player == "x"{
            winner = "x"
        }else if playerInputs[2].player == "o" && playerInputs[4].player == "o" && playerInputs[6].player == "o"{
            winner = "o"
        }
        
        if winner != "" {
            let alert = UIAlertController(title: "Tic Tac Toe", message: "The winner is \(winner)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction:UIAlertAction!) -> Void in
                self.gameReset()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func inputTapped(gestureRecognizer:UITapGestureRecognizer) {
        let fieldTapped = gestureRecognizer.view as! PlayerInputImageView
        fieldTapped.setPlayer(player: currentPlayer)
        
        let messageDict = ["fieldTag":fieldTapped.tag, "player":currentPlayer] as [String : Any]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.multipeerConnectivityHandler.session.send(messageData, toPeers: appDelegate.multipeerConnectivityHandler.session.connectedPeers, with: .reliable)
        }
        catch _ {
            print("Error in input tapped")
        }
        
        checkResult()
        // Checking results
        
    }
    
    func peerStateChangedNotification(notification:NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.value(forKey: "state") as! Int
        
        if state == MCSessionState.connected.rawValue {
            self.navigationItem.title = "Connected"
        } else if state == MCSessionState.notConnected.rawValue {
            self.navigationItem.title = "Not Connected"
        }
        
    }
    
    func handleReceivedDataWithNotification(notification:NSNotification) {
        let userInfo = notification.userInfo
        let receivedData:NSData = userInfo!["data"] as! NSData
        do {
            let message = try JSONSerialization.jsonObject(with: receivedData as Data, options: .allowFragments) as! NSDictionary
            let senderPeerID:MCPeerID = userInfo!["peerID"] as! MCPeerID
            let senderDisplayName = senderPeerID.displayName
            
            if (message.object(forKey: "message") as AnyObject).isEqual("New Game") == true{
                let alert = UIAlertController(title: "Tic Tac Toe", message: "\(senderDisplayName) has started new game", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction:UIAlertAction!) -> Void in
                    self.gameReset()
                }))
                self.present(alert, animated: true, completion: nil)
//                gameReset()
            } else {
                let fieldTag:Int? = message.object(forKey: "fieldTag") as? Int
                let player:String? = message.object(forKey: "player") as? String
                
                if fieldTag != nil &&  player != nil{
                    playerInputs[fieldTag!].player = player
                    playerInputs[fieldTag!].setPlayer(player: player!)
                    
                    currentPlayer = player == "x" ? "o" : "x"
                    
                    // TODO: Check for result
                    checkResult()
                }
            }
        }
        
        catch _ {
            print("Error in handling the device data")
        }
    }
    
    // MCBrowserViewControllerDelegate methods
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }

}

