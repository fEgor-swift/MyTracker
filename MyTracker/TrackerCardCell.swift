import UIKit

final class TrackerCardCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCardCell"

    var onToggleTapped: (() -> Void)?

    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()

    private let daysCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tracker: Tracker, isCompleted: Bool, completedDaysCount: Int) {
        let backgroundColor = UIColor(named: tracker.color) ?? UIColor(hex: tracker.color)
        cardView.backgroundColor = backgroundColor
        emojiBackgroundView.backgroundColor = UIColor(named: "ypWhite")?.withAlphaComponent(0.3)

        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        daysCounterLabel.text = "\(completedDaysCount) \(pluralizedDay(completedDaysCount))"

        let imageName = isCompleted ? "checkmark" : "plus"
        let image = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        )
        toggleButton.setImage(image, for: .normal)
        toggleButton.backgroundColor = isCompleted ? backgroundColor.withAlphaComponent(0.3) : backgroundColor
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        contentView.addSubview(daysCounterLabel)
        contentView.addSubview(toggleButton)
        
        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        cardView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            daysCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCounterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),

            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleButton.centerYAnchor.constraint(equalTo: daysCounterLabel.centerYAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 34),
            toggleButton.heightAnchor.constraint(equalToConstant: 34)
        ])

        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }

    @objc private func toggleButtonTapped() {
        onToggleTapped?()
    }

    private func pluralizedDay(_ count: Int) -> String {
        let rem10 = count % 10
        let rem100 = count % 100
        if rem100 >= 11 && rem100 <= 14 { return "дней" }
        switch rem10 {
        case 1: return "день"
        case 2...4: return "дня"
        default: return "дней"
        }
    }
}
