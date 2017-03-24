//
//  HomeViewController.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/21.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit

private let kTitleViewH:CGFloat =  40

class HomeViewController: UIViewController {
    
    
   
    //定义标题 懒加载一个pageTitleView
    lazy var pageTitleView:PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH+kNaviationBarH, width: kScreenW, height: kTitleViewH)
        let titles=["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    
    //懒加载一个pageContenView  创建pageContenView
    lazy var pageConentView:PageContentView = {[weak self] in
        
        //1、确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNaviationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kNaviationBarH+kStatusBarH+kTitleViewH, width: kScreenW, height: contentH)
        
        //2、确定所有子控制器(创建四个childviewcontroller)
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc) //这里只是将子控制器放入一个数组 然后作为构造参数传入构造器。具体实现由PageControllerView来实现
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self!)
        contentView.delegate = self
        return contentView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //调用setupUI方法来设置ui
        setupUI()
        
    }
}



//设置我门的UI界面
extension HomeViewController{
     func setupUI(){
        //0、不需要调整UIscrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1、设置导航栏
        setipNavigationBar()
        
        //2、添加TitleView
        self.view.addSubview(pageTitleView)
        
        //3、添加contentView
        view.addSubview(pageConentView)
        pageConentView.backgroundColor = UIColor.orange
        
        
        
    }
    
    private func setipNavigationBar(){
        //设置左侧的item
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
        button.sizeToFit()
        navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: button)
        
        
        //设置右侧items
        let historyItem = UIBarButtonItem.creatItem(image: #imageLiteral(resourceName: "image_my_history"), hightImage: #imageLiteral(resourceName: "Image_my_history_click"), size: CGSize(width: 40, height:40))
        let searchItem = UIBarButtonItem.creatItem(image: #imageLiteral(resourceName: "btn_search"), hightImage: #imageLiteral(resourceName: "btn_search_clicked"), size: CGSize(width: 40, height:40))
        let qrcodeItem = UIBarButtonItem.creatItem(image: #imageLiteral(resourceName: "Image_scan"), hightImage: #imageLiteral(resourceName: "Image_scan_click"), size: CGSize(width: 40, height:40))
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}


//遵守pagetitleViewdelegate协议
extension HomeViewController:PageTitleViewDelegate{
    func PageTitleViewSend(titleView: PageTitleView, selectedIndex index: Int) {
        pageConentView.setCurrentIndex(currentIndex: index)
    }
}

//遵守pageContentViewdelegate协议
extension HomeViewController:PageContentViewDelegate{
    func PageContentViewSend(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
