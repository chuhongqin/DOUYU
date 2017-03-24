//
//  ReCommendCycleView.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/24.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit
private let kCycleCellID = "kCycleCellID"
class ReCommendCycleView: UIView {
    
    //定义属性
    var cycleTimer:Timer?
    var cycleModels : [CycleModel]?{
        didSet{
            //刷新collectionView
            collectionView.reloadData()
            //设置pageContro的个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            //默认滚动到中间某个位置。这样子往前滚也可以了
            let indexPath = NSIndexPath(item: (cycleModels?.count ?? 0)*100, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
            
            //添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    //控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //系统回调
    override func awakeFromNib() {
        
        //设置该控件不随着父控件拉伸而拉伸
        autoresizingMask = . init(rawValue: 0)
        //注册cell
       
        collectionView.register( UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
    }
    
   override func layoutSubviews() {
        super.layoutSubviews()
        //设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.frame.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
    }
}


//提供一个快速创建view类方法
extension ReCommendCycleView{
    class func recommendCycleView()->ReCommendCycleView{
        return Bundle.main.loadNibNamed("ReCommendCycleView", owner: nil, options: nil)?.first as! ReCommendCycleView
    }
}
//遵守uicollectionview的datasource协议
extension ReCommendCycleView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell 
        cell.cycleModel = cycleModels![indexPath.item % (cycleModels?.count)!]
        return cell
    }
}
//遵循uicollectionView的代理协议
extension ReCommendCycleView:UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        //2.计算pageConttoller的CurrentIndex
       pageControl.currentPage =  Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

//对定时起到操作方法
extension ReCommendCycleView{
     func addCycleTimer(){
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector:#selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: .commonModes)
    }
     func removeCycleTimer(){
        cycleTimer?.invalidate()//从运行循环中移除
        cycleTimer = nil
    }

    @objc  func scrollToNext(){
            //先拿到当前的offset
        let currentOffset = collectionView.contentOffset.x
        let offSetX = currentOffset + collectionView.bounds.width
        //滚动到该位置
        collectionView.setContentOffset(CGPoint.init(x: offSetX, y: 0), animated: true)
    }

}


