//
//  SharedCode.swift
//  Project12
//
//  Created by Ian McDonald on 20/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
