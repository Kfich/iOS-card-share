//
//  Copyright (c) 2016 Algolia
//  http://www.algolia.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit


/// A collection view displaying a contact.
///
class ContactCell: UITableViewCell {
    
    // Properties
    // --------------------------------------
    
    var contact: ContactRecord? {
        didSet {
            titleLabel.highlightedText = contact?.title_highlighted
            if let url = contact?.imageUrl {
                posterImageView.setImageWith(url, placeholderImage: ContactCell.placeholder)
            } else {
                posterImageView.cancelImageDownloadTask()
                posterImageView.image = ContactCell.placeholder
            }
        }
    }
    
    // IBOutlets
    // --------------------------------------
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    // IBActions / Buttons pressed
    // --------------------------------------
    
    @IBAction func imageViewSelected(_ sender: AnyObject) {
        
        // Post notification when item selected
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactIntroSelected"), object: self)
        
    }
    
    

    static let placeholder = UIImage(named: "placeholder")!
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
