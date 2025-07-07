import UIKit

class ChatTableViewCell: UITableViewCell {
    static let identifier = "ChatTableViewCell"
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = .cellColor
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
