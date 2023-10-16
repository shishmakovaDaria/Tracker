//
//  ViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    var viewModel: TrackersViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .ypWhite
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            TrackersHeaders.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header")
        return collectionView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Trackers".localized()
        label.font = .boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Search".localized()
        searchTextField.textColor = .ypBlack
        searchTextField.delegate = self
        searchTextField.returnKeyType = .go
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged), for: .editingChanged)
        return searchTextField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar.firstWeekday = 2
        datePicker.locale = .current
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
        
    private lazy var placeholder: UIImageView = {
        let placeholder = UIImageView()
        placeholder.image = UIImage(named: "Star")
        placeholder.clipsToBounds = true
        return placeholder
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "What will we track?".localized()
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return placeholderLabel
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.setTitle("Filters".localized(), for: .normal)
        filterButton.backgroundColor = .ypBlue
        filterButton.layer.cornerRadius = 16
        filterButton.addTarget(self, action: #selector(filterButtonDidTap(_:)), for: .touchUpInside)
        return filterButton
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
        viewModel?.updateDatePickerDate(date: datePicker.date)
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.viewWillDisappear()
    }
    
    @objc private func filterButtonDidTap(_ sender: Any?) {
        viewModel?.filterButtonDidTap()
        let vc = FilterViewController()
        vc.viewModel = FilterViewModel()
        vc.viewModel?.delegate = self.viewModel
        vc.viewModel?.currentFiler = viewModel?.trackerFiler
        present(vc, animated: true)
    }
    
    @objc private func dateChanged() {
        viewModel?.updateDatePickerDate(date: datePicker.date)
    }
    
    @objc private func searchTextFieldChanged() {
        viewModel?.updateSearchText(text: searchTextField.text ?? "")
    }
    
    func showTrackersCreationViewController() {
        let vc = TrackersCreationViewController()
        vc.controller = self
        present(vc, animated: true)
    }
    
    private func bind() {
        viewModel?.$visibleCategories.bind { [weak self] _ in
            self?.collectionView.reloadData()
            self?.reloadPlaceholder()
        }
        
        viewModel?.$currentDate.bind { [weak self] currentDate in
            self?.datePicker.date = currentDate ?? Date()
        }
    }
    
    private func reloadPlaceholder() {
        if let viewModel = viewModel {
            placeholder.isHidden = !viewModel.categories.isEmpty
            placeholder.isHidden = !viewModel.visibleCategories.isEmpty
            placeholderLabel.isHidden = !viewModel.categories.isEmpty
            placeholderLabel.isHidden = !viewModel.visibleCategories.isEmpty
            filterButton.isHidden = viewModel.categories.isEmpty
            filterButton.isHidden = viewModel.visibleCategories.isEmpty
        }
    }
    
    private func editTracker(indexPath: IndexPath) {
        viewModel?.editButtonDidTap()
        guard let trackerToEdit = viewModel?.findTracker(indexPath: indexPath) else { return }
        
        let vc = TrackerEditingViewController()
        vc.viewModel = TrackerEditingViewModel()
        vc.viewModel?.delegate = self.viewModel
        vc.viewModel?.trackerToEdit = trackerToEdit
        vc.viewModel?.trackerRecord = viewModel?.findRecord(idToFind: trackerToEdit.id)
        vc.viewModel?.updateValues(category: viewModel?.findCategory(trackerId: trackerToEdit.id) ?? "")
        present(vc, animated: true)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        viewModel?.didTapDelete()
        let alert = UIAlertController(title: "Уверены, что хотите удалить трекер?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            viewModel?.deleteTracker(indexPath: indexPath)
        }
        
        let action2 = UIAlertAction(title: "Отменить", style: .cancel) {_ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)

        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        [collectionView, label, searchTextField, datePicker, placeholder, placeholderLabel, filterButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            
            searchTextField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            searchTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.visibleCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.visibleCategories[section].trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? TrackersCell else { return UICollectionViewCell()}
        
        guard let cellModel = viewModel?.configureCellModel(indexPath: indexPath) else { return UICollectionViewCell()}
        cell.configureCell(cellModel: cellModel)

        cell.buttonTappedHandler = { [weak self] in
            self?.viewModel?.handleButtonTapped(indexPath: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackersHeaders else { return UICollectionReusableView() }
        
        if viewModel?.visibleCategories.count == 0 {
            return UICollectionReusableView()
        } else {
            view.titleLabel.text = viewModel?.visibleCategories[indexPath.section].header
            view.titleLabel.font = .boldSystemFont(ofSize: 19)
            return view
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 10) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: (collectionView.frame.width - 56),
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

//MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCell else { return nil }
        
        guard let firstActionName = viewModel?.provideActionName(indexPath: indexPath) else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "\(firstActionName)") { [weak self] _ in
                    self?.viewModel?.pinTracker(indexPath: indexPath, cell: cell)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.editTracker(indexPath: indexPath)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.deleteTracker(indexPath: indexPath)
                },
            ])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCell else { return nil }
        return UITargetedPreview(view: cell.colorView)
    }
}

//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel?.updateSearchText(text: searchTextField.text ?? "")
        
        return true
    }
}
