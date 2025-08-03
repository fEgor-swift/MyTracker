import UIKit

final class TrackerSectionHeaderView: UICollectionReusableView {

    static let reuseID = "TrackerSectionHeaderView"

    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor(named: "ypBlack") ?? .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(sectionTitleLabel)
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupTitle(with text: String) {
        sectionTitleLabel.text = text
    }
}
