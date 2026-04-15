import UIKit

class ChatTableViewAnswerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    
    var cellDict = [String: Any]()
    
    func initUI(){
        
        self.selectionStyle = .none
        
        messageView.backgroundColor = NavTalkManager.shared.navtalk_messageItem_ai_backgroundColor
        messageLabel.textColor = NavTalkManager.shared.navtalk_messageItem_ai_titleColor
        messageLabel.font = NavTalkManager.shared.navtalk_messageItem_ai_titleFont
        messageView.layer.cornerRadius = NavTalkManager.shared.navtalk_messageItem_ai_cornerRadius
        
        let message = cellDict["content"] as? String ?? ""
        let tableView_width = NavTalkManager.shared.navtalk_messageList_frame?.width ?? (kScreen_WIDTH-100)
        let textHeight = calculateHeight(forText: message, withFont: messageLabel.font, andWidth: tableView_width-30)
        if textHeight < 20.0{
            messageViewHeight.constant = 36.0
            let textWidth = calculateWidth(forText: message, withFont: messageLabel.font, andHeight: textHeight)
            if textWidth >= tableView_width-30{
                messageViewWidth.constant = tableView_width-30+20
            }else{
                messageViewWidth.constant = textWidth+20
            }
        }else{
            messageViewHeight.constant = textHeight + 20
            messageViewWidth.constant =  tableView_width-30+20
        }
        messageLabel.text = message

    }
   
}
