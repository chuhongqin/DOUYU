//
//  PageTitleView.swift
//  DY_WYY
//
//  Created by 褚红钦 on 2017/3/21.
//  Copyright © 2017年 褚红钦. All rights reserved.
//

import UIKit



protocol PageTitleViewDelegate:class {
    func PageTitleViewSend(titleView:PageTitleView,selectedIndex index:Int)
}

//定义常量
private let kScrollLineH:CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedColor:(CGFloat,CGFloat,CGFloat) = (255,128,0)


class PageTitleView: UIView {
    //定义属性
    var titles:[String]
    var currenIndex:Int = 0
    weak var delegate:PageTitleViewDelegate?
   
    
    //懒加载属性 --定义一个scrollview。 线，这里没有定义划线的frame 在调用的时候定义
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false // 默认是false。是否显示翻页
        scrollView.bounces = false
        return scrollView
    
    }()
    
    lazy var labels :[UILabel] = [UILabel]()
    
    
    //懒加载属性，定义一个下划线，这里没有定义划线的frame 在下方定义
    lazy var scrollLIne :UIView = {
        let scrollline = UIView()
        scrollline.backgroundColor = UIColor.orange
        return scrollline
    }()
    
    
    
//------自定义一个构造函数。开始************构造函数在这里！！！！第一步运行这里，然后调用一些方法进行初始化*****************
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)//利用父类的构造方法来初始化frame 
        //1、设置界面
        setupUI()
    }
//------自定义一个构造函数  结束************构造函数在这里！！！！第一步运行这里，然后调用一些方法进行初始化*****************
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//--给PageTitleView添加属性-->设置UI界面
extension PageTitleView{
   

    //这是一个setupUI的方法 里面包含了多个具特方法
    public func setupUI(){
        // 1、添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds //设置scrollview的frame
        // 2、设置对应的titleLabel
        setupTitleLabel()
        //3、设置底线和滚动的滑块
        setupBottomMenuAndScrollLine()
        
    }
    
    
    //创建Label的方法。用传入的titles来创建
    private func setupTitleLabel(){
        
        // 0、label的一些frame值
        let labelW:CGFloat = frame.width/CGFloat(titles.count)
        let labelH:CGFloat = frame.height - kScrollLineH
        let labelY:CGFloat=0
        
        for (index,title) in titles.enumerated(){
            // 1、 创建label
            let label = UILabel()
            // 2、 设置label的属性
            label.text=title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
             // 3、 设置label的frame
            let labelX:CGFloat = labelW*CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4、 将label添加到scrollveiw中
            scrollView.addSubview(label)
            labels.append(label)
            
            //5、给label添加手势
            label.isUserInteractionEnabled = true //设置可以与用户交互
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
           
        }
    }
    
    
    //创建底线和滑动的线
    private func setupBottomMenuAndScrollLine(){
        //1、创建底线
        let bottomLine:UIView = UIView()
        bottomLine.backgroundColor = UIColor.lightGray //底线颜色
        let lineH:CGFloat = 0.5 //底线高度
        bottomLine.frame = CGRect(x: 0, y: frame.height-lineH, width:frame.width, height: lineH)
        addSubview(bottomLine) //添加底线到pagetitleview（当前view）
        
        //2、添加crollLine
            // 2.1获取第一个label
            guard let firstlabel = labels.first else {//判断labels的firt是否为空
                return //如果为空直接返回
            }
            firstlabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)//给第一个label添加颜色
            //2.2设置scrollLine的属性
            scrollLIne.frame = CGRect(x: firstlabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstlabel.frame.width, height: kScrollLineH  )
        
            scrollView.addSubview(scrollLIne)
        
    }
    
}

//监听label的点击
extension PageTitleView{
    @objc  func titleLabelClick(tapGes:UITapGestureRecognizer){
        //0、获取当前label
        guard let currentLabel = tapGes.view as? UILabel else {return }
        //1、判断是否已选中
        if currentLabel.tag == currenIndex {return}
        //2、获取之前的label
        let oldLabel = labels[currenIndex]
        
        //3、修改文字的颜色
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //4、保存下标值
        currenIndex = currentLabel.tag
        
        //5、改变滚动条位置
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLIne.frame.width
        UIView.animate(withDuration: 0.15) { 
            self.scrollLIne.frame.origin.x = scrollLineX
        }
        //6、通知代理做事情
        delegate?.PageTitleViewSend(titleView: self, selectedIndex: currentLabel.tag)
    }
}

//对外暴露的方法 --HomeControllerView中可以调用此方法
extension PageTitleView{
    func setTitleWithProgress(progress:CGFloat,sourceIndex:Int,targetIndex:Int){
        // 1、取出sourceLabel和targetLabel
        let sourceLabel = labels[sourceIndex]
        let targetLabel = labels[targetIndex]
        //2、处理滑块逻辑
        let moveTitleX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTitleX * progress
        scrollLIne.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //3、label颜色渐变
            //3.1、取出变化的范围
        let colorDelta = (kSelectedColor.0-kNormalColor.0,kSelectedColor.1-kNormalColor.1,kSelectedColor.2-kSelectedColor.2)//红绿蓝三种颜色的变化范围
        //3.2变化sourcelabel
        sourceLabel.textColor = UIColor(r: kSelectedColor.0-colorDelta.0*progress, g: kSelectedColor.1-colorDelta.1*progress, b: kSelectedColor.2-colorDelta.2*progress)
        //3、3 变化targetlabel
        targetLabel.textColor = UIColor(r: kNormalColor.0+colorDelta.0*progress, g: kNormalColor.1+colorDelta.1*progress, b:kNormalColor.2+colorDelta.2*progress)
        //4、记录最新的index
        currenIndex = targetIndex
        
    }
}
