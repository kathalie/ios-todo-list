//
//  Util.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import Foundation

func dueDateFormat(of date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yy HH:mm")
    
    return dateFormatter.string(from: date)
}
