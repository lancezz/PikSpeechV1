//
//  Initializer.swift
//  PikSpeech.V1
//
//  Created by Miguel Taningco on 2018-11-04.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import UIKit

class Initializer: NSObject {
    
    static func getCategoryData() -> [TileData]{
        var categoryDataArray = [TileData]()
        
        //append the amount of categories that you want
        categoryDataArray.append(TileData("cat", "Animals"))
        categoryDataArray.append(TileData("glasses", "Clothing"))
        categoryDataArray.append(TileData("Milk", "Drinks"))
        categoryDataArray.append(TileData("Love", "Feelings"))
        categoryDataArray.append(TileData("Pizza", "Food"))
        
        return categoryDataArray
    }
    
    static func getCategorySize() -> Int{
        return 5
    }
    
    static func getAppDataTileData() -> [[TileData]]{
        let imageName2DArray = [
            ["bear","cat","chicken","cow","dog","fish","pig","rabbit","squirrel","turtle"],
            ["glasses","gloves","hat","jacket","shirt","shoes","shorts","socks"],
            ["Juice","Milk","Soda","Tea"],
            ["Angry","Cold","confused","disgust","Happy","Hot","hungry","Love","Sad","shocked","Sick","Sleepy"],
            ["Bagels","burger","carrot","cheese","Chocolate","Eggs","Ice-cream","nuts","pasta","Pizza","potato","Sandwich","vegetables"]
        ]
        var appDataTileDataArray = [[TileData]]()
        
        print("number of categories: \(getCategorySize())")
        for i in 0...getCategorySize() - 1{
            appDataTileDataArray.append([TileData]())
            print("current size of appTileDataArray: \(appDataTileDataArray.count)")
            for j in 0...imageName2DArray[i].count - 1{
                print("size of the 2dArray at index \(i): \(imageName2DArray[i].count)  | j = \(j)")
                appDataTileDataArray[i].append(TileData(imageName2DArray[i][j], imageName2DArray[i][j]))
            }
        }
        
        //        for i in 0...getCategorySize(){
        //            for j in 0...imageName2DArray[i].count{
        //                appDataTileDataArray[i][j] = TileData(imageName2DArray[i][j], imageName2DArray[i][j])
        //            }
        //        }
        //for each category, for each tile, append that onto the appDataTileData
        
        
        return appDataTileDataArray
    }
    
    static func getDefaultSelectionBarData() -> [TileData]{
        var appDataTileDataArray = getAppDataTileData()
        
        return appDataTileDataArray[0]
    }
}
