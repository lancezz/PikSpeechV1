//
//  TileDataManager.swift
//  PikSpeech.V1
//
//  Created by Lance Zhang on 2018-11-17.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TileDataManager {
    static func downloadAllSelectionDataAs2DArray(selectionCollectionView: UICollectionView, categoryCollectionView: UICollectionView,tileData2DArray : [[TileData]], categoryDataArray : [TileData], selectionBarTileData : [TileData]){
        //do the observe
            //have the snapshot
            //2d loop it so that you can update the tileData2DArray
            //similarly, we update the categoryDataArray
        
            //at this point, your 2d array has been completely updated, which means it is ready to use for reloading data, also your categoryDataArray has been updated as well
            //now you can reload your selectionBarTileData as well
            //reload selectionCollectionView, categoryCllectionView
    }
}
