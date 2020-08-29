//
//  ViewController.swift
//  BackgroundLoading
//
//  Created by Mac on 29.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class ViewControllerViewModel {
    private let dataManager = DataManager()
    let disposeBag = DisposeBag()
    let publishedObject = BehaviorSubject<Example?>(value: nil)
    init() {
        DispatchQueue.global(qos: .background).async {
            self.dataManager.publishedObject.asObserver().map { (result) in
                self.publishedObject.onNext(result)
            }.subscribe().disposed(by: self.disposeBag)
        }
    }
    func get(){
        DispatchQueue.global(qos: .background).async {
            self.dataManager.getPhotos()
        }
    }
}

class ViewController: UIViewController {

    private var collectionViewFlowLayout : UICollectionViewFlowLayout!
    private var collectionView : UICollectionView!
    private var collectionViewIdentifier = "collectionView"
    private var viewModel = ViewControllerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setCollectionView()
        
        self.viewModel.publishedObject.asObserver().map { (result) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.subscribe().disposed(by: self.viewModel.disposeBag)

        //Just for see animation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.viewModel.get()
        }
    }
}
extension ViewController {
    private func setCollectionView(){
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 300)
        self.collectionViewFlowLayout.minimumLineSpacing = 10
    
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: self.collectionViewIdentifier)
        self.collectionView.backgroundColor = .clear
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            if let value = try self.viewModel.publishedObject.value() {
                return value.data.count
            }
        }catch {
            print("error")
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewIdentifier, for: indexPath) as? CollectionViewCell else {fatalError()}
        do {
            if let value = try self.viewModel.publishedObject.value() {
                let data = value.data[indexPath.row]
                cell.setData(title: data.title)
            }
        }catch {
            print(error.localizedDescription)
        }
        
        
        return cell
    }
}



extension UIView {
    func startLoadingAnimation(){
        let gradientLayer : CAGradientLayer = CAGradientLayer()
               
        gradientLayer.colors = [UIColor.clear.cgColor , UIColor.lightGray.cgColor , UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0 , 0.5 , 1]
        gradientLayer.frame = self.bounds
        self.layer.mask = gradientLayer
        
        
        let loadingAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        loadingAnimation.duration = 1
        loadingAnimation.fromValue = -self.bounds.width
        loadingAnimation.toValue = self.bounds.width
        loadingAnimation.repeatCount = .infinity
        gradientLayer.add(loadingAnimation, forKey: "animationKey")
    }
    func stopLoadingAnimation(){
        if let mask = self.layer.mask {
            DispatchQueue.main.async {
                mask.removeAllAnimations()
                mask.removeFromSuperlayer()
            }
        }
    }
}
