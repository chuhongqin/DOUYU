
import UIKit

protocol PageContentViewDelegate:class {
    func PageContentViewSend(contentView:PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}


private let contentCellId = "contentCellId"

class PageContentView: UIView {
     var delegate:PageContentViewDelegate?
//定义属性--（保存初始化的时候传进来的东西）
    var childVcs:[UIViewController]
    weak var parentViewController:UIViewController?
    var startOffsetX:CGFloat = 0
    var isForbitScrollDelegate:Bool = false//是否禁止滚动代理
   
    //懒加载属性 创建collectionView
    lazy var collectionView:UICollectionView = {[weak self] in
        
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0 // 行间距
        layout.minimumInteritemSpacing = 0 //列间距
        layout.scrollDirection = .horizontal //滚动方向
        
        //2、创建UIcolletionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false //水平方向指示器设为false 不显示
        collectionView.isPagingEnabled = true//是否分页显示
        collectionView.bounces  = false //设置边缘不可以超出滚动区域
        collectionView.dataSource = self
        collectionView.delegate = self        //注册collectionView
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellId)
        
        return collectionView
    }()
    
/*
 init初始化函数
     参数1:frame:       该view的frame
     参数2:childVcs:    要添加的子视图数组
     参数3：parentViewController   父视图，将子视图数组中的视图添加到该父视图中去
 */
    init(frame: CGRect,childVcs:[UIViewController],parentViewController:UIViewController) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)//frame的初始化调用了夫类的构造函数
        //设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}


//设置UI界面
extension PageContentView{
     func setupUI(){
        //1、将所有的子控制器添加到付控制器中
        for childVc in childVcs{
            parentViewController?.addChildViewController(childVc)
        }
        
        //2、添加UICollectionView,用于在cell存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


//遵循collectionViewDataSoure  实现collectionViewDataSource的 个委托方法（一共三个）
extension PageContentView:UICollectionViewDataSource{
    // 方法一 ：设置siction的数量(默认为 1)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 方法二： 设置某个section里有多少个item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    // 方法三： 设置对于某个位置应该显示什么样的cell （返回每个cell）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1、创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellId, for: indexPath)
        //2、给cell设置内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

//遵循collectionViewDelegate 
extension PageContentView:UICollectionViewDelegate{
    
    //开始拖拽的方法
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbitScrollDelegate = false
       startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断是否是点击事件
        if isForbitScrollDelegate {return }
        
        //1、定义需要的数据
        var progress:CGFloat = 0// 进度
        var sourceIndex:Int = 0 //源下标
        var targetIndex:Int = 0 //目标下表
        //2、判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width//scrolllview的宽度
        
        if currentOffsetX > startOffsetX{
            //左滑
            //1、计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //2、计算sourceindex
            sourceIndex = Int(currentOffsetX/scrollViewW)
            //3、计算targetindex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //4、如果完全滑过去
            if currentOffsetX  - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }

        }else{//右滑
            //1、计算progress
            progress = 1-( currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            //2、计算targetindex
            targetIndex = Int( currentOffsetX / scrollViewW)
            //3、计算sourceindex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count-1
            }
            //4、如果完全滑过去
            if currentOffsetX  - startOffsetX == -scrollViewW{
                progress = 1
                 sourceIndex = targetIndex
            }
        }
        
        //3、将progress curentindex sourceindex传递给titleview
        //通知代理。因为在homepageviewController中将PageContentView的delegate设置为HomeViewcontroller所以这里执行delegate的方法就是让homeviewcontroller的对象去执行
        delegate?.PageContentViewSend(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//对外爆露的方法 --- 让homeviewcontroller去调用
extension PageContentView{
    func setCurrentIndex(currentIndex:Int){
        //1、记录需要禁止执行代理方法
        isForbitScrollDelegate = true
        //2、设置滑块的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
    }
}





