//
//  Array+RandomElement.swift
//  BubblePop
//
//  Copyright © 2018 Jason Kumar. All rights reserved.
//

import Foundation

extension Array
{
    func randomItem() -> Element?
    {
        if isEmpty
        {
            return nil
        }
        
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
