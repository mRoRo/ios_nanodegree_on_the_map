//
//  UiUtils.swift
//  OnTheMap
//
//  Created by Maro on 29/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
