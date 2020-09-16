//
//  HomeCardTableCell.swift
//  Unify
//


import UIKit


class HomeCardTableCell: UITableViewCell {


    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print(collectionView.layer.frame.width)
        
    }
    




}
