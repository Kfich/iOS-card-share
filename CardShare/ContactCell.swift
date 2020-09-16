
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
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var mediaButtonToolBar: UIToolbar!
    
    
    // Media buttons
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    
    
    // IBActions / Buttons pressed
    // --------------------------------------
    
    /*
    @IBAction func imageViewSelected(_ sender: AnyObject) {
        
        // Post notification when item selected
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContactIntroSelected"), object: self)
        
    }*/
    
    
    
    
    

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
