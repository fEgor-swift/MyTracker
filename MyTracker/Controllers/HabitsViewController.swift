import UIKit

final class HabitsViewController: UIViewController {
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Привычки", trackers: [])
    ]
    var completedTrackers: [TrackerRecord] = []
    private var filteredCategories: [TrackerCategory] = []
    private var selectedDate = Date()
    
    private let createButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "ButtonIcon"), for: .normal) // <-- Оригинальное название
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
        field.backgroundColor = UIColor(hex: "#767680", alpha: 0.12)
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
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .systemBlue
        return picker
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        layoutUI()
        setupLayoutConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCardCell.self, forCellWithReuseIdentifier: TrackerCardCell.reuseIdentifier)
        collectionView.register(
            TrackerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeaderView.reuseID
        )
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        filterTrackers(for: selectedDate)
    }

    private func configureNavigation() {
        buttonWrapper.addSubview(createButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonWrapper)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func layoutUI() {
        view.addSubview(headerLabel)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(noDataStack)
        
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
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
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noDataStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekdaySymbol = calendar.weekdaySymbols[(weekday + 5) % 7]

        filteredCategories = categories.map { category in
            let trackers = category.trackers.filter { $0.schedule.contains(weekdaySymbol) }
            return TrackerCategory(title: category.title, trackers: trackers)
        }.filter { !$0.trackers.isEmpty }

        collectionView.reloadData()
        noDataStack.isHidden = !filteredCategories.isEmpty
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        filterTrackers(for: selectedDate)
    }
    
    @objc private func didTapCreateButton() {
        let vc = HabitEditorViewController()
        vc.modalPresentationStyle = .automatic
        vc.didCreateNewTracker = { [weak self] tracker in
            guard let self else { return }

            if let index = self.categories.firstIndex(where: { $0.title == "Привычки" }) {
                var updated = self.categories[index]
                updated.trackers.append(tracker)
                self.categories[index] = updated
            } else {
                self.categories.append(TrackerCategory(title: "Привычки", trackers: [tracker]))
            }
            self.filterTrackers(for: self.selectedDate)
        }
        present(vc, animated: true)
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardCell else {
            return UICollectionViewCell()
        }

        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let isCompleted = completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }

        cell.configure(
            with: tracker,
            isCompleted: isCompleted,
            completedDaysCount: completedTrackers.filter { $0.trackerId == tracker.id }.count
        )

        cell.onToggleTapped = { [weak self] in
            guard let self else { return }
            let today = Date()
            if selectedDate > today { return }

            if isCompleted {
                self.completedTrackers.removeAll {
                    $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: self.selectedDate)
                }
            } else {
                self.completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: self.selectedDate))
            }

            collectionView.reloadItems(at: [indexPath])
        }

        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerSectionHeaderView.reuseID,
                for: indexPath
              ) as? TrackerSectionHeaderView else {
            return UICollectionReusableView()
        }

        let category = filteredCategories[indexPath.section]
        header.setupTitle(with: category.title)
        return header
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 8) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 32)
    }
}
