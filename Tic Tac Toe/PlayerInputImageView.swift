//
//  PlayerInputImageView.swift
//  Tic Tac Toe
//
//  Created by Vignan Sankati on 5/12/17.
//  Copyright © 2017 Vignan Sankati. All rights reserved.
//

import UIKit

class PlayerInputImageView: UIImageView {
    var player:String?
    var activated = false
    
    func setPlayer(player:String) {
        self.player = player
        
        if !activated {
            if player == "x" {
                self.image = UIImage(named: "x")
            } else {
                self.image = UIImage(named: "o")
            }
            activated = true
        }
    }
}
