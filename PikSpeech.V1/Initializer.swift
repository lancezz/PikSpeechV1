//
//  Initializer.swift
//  PikSpeech.V1
//
//  Created by Miguel Taningco on 2018-11-04.
//  Collaboration with Lance Zhang and Sheel Soneji
//  Copyright © 2018 CMPT 275 Group11: A-team. All rights reserved.
//
//  Change Log:
//      11/04/2018: Created getCategoryData function                    (Miguel Taningco)
//                  Created getCategorySize function                    (Miguel Taningco)
//                  Created getAppTileData function                     (Miguel Taningco)
//                  Created getDefaultSelectionBarData function         (Miguel Taningco)
//                  Updated 1D and 2D array data structure information  (Lance Zhang)
//      11/05/2018: Provided documentation                              (Miguel Taningco)

import UIKit



//Initializer Class initializes arrays of TileData necessary for the ViewController
class Initializer: NSObject {
    
    //  Returns an array of TileData containing information about the categories
    static func getCategoryData() -> [TileData]{
        var categoryDataArray = [TileData]()
        
        categoryDataArray.append(TileData("cat", "Animals"))
        categoryDataArray.append(TileData("glasses", "Clothing"))
        categoryDataArray.append(TileData("Milk", "Drinks"))
        categoryDataArray.append(TileData("Love", "Feelings"))
        categoryDataArray.append(TileData("Pizza", "Food"))
        categoryDataArray.append(TileData("go","common"))
        categoryDataArray.append(TileData("girl","people"))
        
        return categoryDataArray
    }
    
    //  Returns an Int representing the amount of categories
    static func getCategorySize() -> Int{
        return 7
    }
    
    //  Returns a 2D array TileData containing information of each tile in the specific category
    static func getAppDataTileData() -> [[TileData]]{
        let imageName2DArray = [
            ["bear","cat","chicken","cow","dog","fish","pig","rabbit","squirrel","turtle"],
            ["glasses","gloves","hat","jacket","shirt","shoes","shorts","socks"],
            ["Juice","Milk","Soda","Tea"],
            ["Angry","Cold","confused","disgust","Happy","Hot","hungry","Love","Sad","shocked","Sick","Sleepy"],
            ["Bagels","burger","carrot","cheese","Chocolate","Eggs","Ice-cream","nuts","pasta","Pizza","potato","Sandwich","vegetables"],
            ["go","i","like","no","question","stop","you","yeet"],
            ["baby","boy","dad","girl","grandpa"]
        ]
        var appDataTileDataArray = [[TileData]]()
        
//        print("number of categories: \(getCategorySize())")
        for i in 0...getCategorySize() - 1{
            appDataTileDataArray.append([TileData]())
//            print("current size of appTileDataArray: \(appDataTileDataArray.count)")
            for j in 0...imageName2DArray[i].count - 1{
//                print("size of the 2dArray at index \(i): \(imageName2DArray[i].count)  | j = \(j)")
                appDataTileDataArray[i].append(TileData(imageName2DArray[i][j], imageName2DArray[i][j]))
            }
        }
        
        return appDataTileDataArray
    }
    
    //Returns an array of TileData from the first category
    static func getDefaultSelectionBarData() -> [TileData]{
        var appDataTileDataArray = getAppDataTileData()
        
        return appDataTileDataArray[0]
    }
}
