
import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    private var view: HomeCell = HomeCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        view.pinToBounds(of: contentView)
        backgroundColor = .clear
    }
    
    public func fill(dto: HomeCellDTO) {
        view.fill(dto: dto)
        view.layoutIfNeeded()
        layoutIfNeeded()
        contentView.layoutIfNeeded()
    }
}
