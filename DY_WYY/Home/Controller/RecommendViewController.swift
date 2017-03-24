//
//  RecommendViewController.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/22.
//  Copyright © 2017年 褚红钦. All rights reserved.



//-------------------推荐页面控制器------------------
//

import UIKit

//定义常量 
//item之间的间距
private let kItemMargin:CGFloat = 10
//item宽度
private let kItemW = (kScreenW-kItemMargin * 3)/2
//item宽度
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3

//设置cellid
private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
//设置kHeaderViewID
private let kHeaderViewID = "kHeaderViewID"
//组头高度
private let kHeaderViewH :CGFloat = 50
private let kCycleViewH:CGFloat = kScreenW * 3 / 8

class RecommendViewController: UIViewController {
    var commendVM:RecommendViewModel = RecommendViewModel()
    
    //懒加载属性
    lazy var collectionView:UICollectionView = { [unowned self] in
        //1、创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: kItemW, height: kNormalItemH) //设置每个 item 的大小
        layout.minimumLineSpacing = 0           //行间距
        layout.minimumInteritemSpacing = kItemMargin//水平item之间的间距
        layout.headerReferenceSize = CGSize(width:kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin, 0, kItemMargin)
        //2、创建UICollectionView
        let collectionView:UICollectionView = UICollectionView(frame: self.view.bounds,collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]//让collectionview的大小随着父控件 拉伸而拉伸 缩小而缩小
        //注册cell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        //注册cell
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier:kPrettyCellID )

        //从nib中注册header
        collectionView.register( UINib(nibName: "CollectionHeaderView", bundle: nil),forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    
    }()
    
    //懒加载一个cycleView对象
    lazy var cycleView :ReCommendCycleView = {
        let cycleView = ReCommendCycleView.recommendCycleView()
        //任何view必须有frame才能显示
        cycleView.frame  = CGRect(x: 0, y: -kCycleViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
 
    //系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // 设置UI界面
        //发送网络请求
        loadData()
        
        
        
        
    }
}
//发送网络请求
extension RecommendViewController{
 
    func loadData(){
           //请求推荐数据
        commendVM.requestData { 
            self.collectionView.reloadData()
        }
        //请求轮播数据
        commendVM.requestCycleData { 
            self.cycleView.cycleModels = self.commendVM.cycleModels
        }
    }
}


//给RecommendViewController添加设置UI界面的方法
extension RecommendViewController {
    func setupUI(){
        //1、将collectionView添加到控制器的view中
        view.addSubview(collectionView)
        //2、将CycleView添加到UICollectionView中
        collectionView.addSubview(cycleView)
        
        //3、给collelctionView设置内边距
        collectionView.contentInset = UIEdgeInsetsMake(kCycleViewH, 0, 0, 0)
    }
}

//遵循UICollectionViewDataSource的数据源协议
extension RecommendViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //设置section的数量。即组数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return commendVM.anchorGroups.count
    }
    
    //设置每组有多少个数据
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = commendVM.anchorGroups[section]
        return group.anchors.count
    }
    
    //设置需要返回的每个cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //取出模型
        let group = commendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        //定义cell
        var cell :CollectionBaseCell!
        //2、取出cell
        if indexPath.section == 1{
           cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
        }else{
           cell =  collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        }
        //4将模型赋值给cell
        cell.anchor = anchor
    
        return cell
    }
    //设置返回的每个组头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1、取出headerview
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView//这里的样式是nib中定义的样式 上面注册.了nib
        //2 取出模型
        headerView.group = commendVM.anchorGroups[indexPath.section]
        //3.
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  indexPath.section == 1{
            return CGSize(width: kItemW, height: kPrettyItemH)
        }else{
            return CGSize(width: kItemW, height: kNormalItemH)
        }
    }
}
