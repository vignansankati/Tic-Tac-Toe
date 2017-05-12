//
//  MultipeerConectivityHandler.swift
//  Tic Tac Toe
//
//  Created by Vignan Sankati on 5/12/17.
//  Copyright © 2017 Vignan Sankati. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultipeerConnectivityHandler: NSObject, MCSessionDelegate {
    
    var peerId:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    
    func setupPeerWithDisplayName(displayName:String) {
        peerId = MCPeerID(displayName: displayName)
    }
    
    func setupSession() {
        session = MCSession(peer: peerId)
        session.delegate = self
    }
    
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType: "TicTacToeGame", session: session)
    }
    
    func advertiseSetup(advertise:Bool) {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "TicTacToeGame", discoveryInfo: nil, session: session)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerId,"state":state.rawValue] as [String : Any]
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil, userInfo: userInfo)
        })
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data":data,"peerID":peerId] as [String : Any]
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil, userInfo: userInfo)
        })
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }

}












