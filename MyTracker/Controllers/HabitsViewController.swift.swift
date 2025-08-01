import UIKit

final class HabitsViewController: UIViewController {

    private let createButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "ButtonIcon"), for: .normal)
        return btn
    }()
    
    private let buttonWrapper: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Трекеры"
        lbl.font = .systemFont(ofSize: 34, weight: .bold)
        lbl.textColor = UIColor(named: "ypBlack")
        return lbl
    }()
    
    private let searchBar: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Поиск"
        field.font = .systemFont(ofSize: 17)
        field.tintColor = UIColor(named: "ypGray")
        field.layer.cornerRadius = 10
        field.layer.masksToBounds = true
        
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = UIColor(named: "ypGray")
        icon.contentMode = .center
        
        let iconWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        icon.frame = CGRect(x: 8, y: 4, width: 16, height: 16)
        iconWrapper.addSubview(icon)
        
        field.leftView = iconWrapper
        field.leftViewMode = .always
        
        return field
    }()
    
    private let noDataImage: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "StarIcon"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let noDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Что будем отслеживать?"
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = UIColor(named: "ypBlack")
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var noDataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noDataImage, noDataLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        layoutUI()
        setupLayoutConstraints()
    }

    private func configureNavigation() {
        buttonWrapper.addSubview(createButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonWrapper)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func layoutUI() {
        view.addSubview(headerLabel)
        view.addSubview(searchBar)
        view.addSubview(noDataStack)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            createButton.leadingAnchor.constraint(equalTo: buttonWrapper.leadingAnchor, constant: -10),
            createButton.centerYAnchor.constraint(equalTo: buttonWrapper.centerYAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 42),
            createButton.heightAnchor.constraint(equalToConstant: 42),
            
            buttonWrapper.widthAnchor.constraint(equalToConstant: 60),
            buttonWrapper.heightAnchor.constraint(equalToConstant: 44),
            
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            noDataStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapCreateButton() {
        print("Нажата кнопка добавления трекера")
    }
}
