# TableViewSectionIndex
解决tableviewSectionindex不能平均的问题
最近的新项目有一个如下的界面
![系统中有index的tableview](http://upload-images.jianshu.io/upload_images/661867-bbbd2c97a5fe146c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

而设计的要求是这样的
![设计图中有index的tableview](http://upload-images.jianshu.io/upload_images/661867-390778aa2fc11a78.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

于是我开始了百度 google stackOverFlow...都没有找到合适的方法.StackOverFlow上的解决方法是给每一个字符后添加一个空字符,注意是数组中的元素后.这也数组长度变大,这样indexTitle中间插入一些空格索引.看起来是变长了,但是需要在返回section高度和返回sectionview以及返回section和index关联三个代理方法中分别设置对于空字符的处理.较为麻烦 而且布局也不够美观.详见[[StackOverFlow]--UITableView section index spacing on iOS 7](http://stackoverflow.com/questions/18923729/uitableview-section-index-spacing-on-ios-7)
另外也有国内开发者对这篇文章的翻译见[[4byte.cn]--在iOS 7表格部分指标间距](http://www.4byte.cn/question/481261/uitableview-section-index-spacing-on-ios-7.html)

下面介绍我的方法,先介绍下整体思路.我是自定义一个indexview,indexview的高度设置为控制器view减去导航条高度和tabbar高度乘以0.91`0.91是一个比例系数,可以适当调高和调低`,放在控制器indexview上.再根据sectionTitles的数量来创建多个letterLabel放在.每个letterLabel高度为indexview的高度除以数组的个数,letterLabel的text设置为数组中各个字符.这样就能保证indexview的高度更加填充慢屏幕,并且每个letterLabel距离平均分布.而对于点击indexview调转到对应的section,我是这样解决的.通过给indexview添加一个tap手势,再通过手势的位置Y除以indexview高度乘以letterLabel高度得到点击的索引indexPath,然后让table滚动到对应的索引.具体代码如下.
####1.创建indexView,指定frame

```swift
        // 113为导航栏高度64 + tabar高度49
        let indexViewH = (kScreenH - 113) * 0.91
        // 这样设置Y保证indexview居中显示
        let indexViewY = ((kScreenH - 113) - indexViewH) * 0.5 + 64
        let indexView = UIView(frame: CGRect(x: kScreenW - 15, y: indexViewY, width: 10, height: indexViewH))
```

####2.根据数据源数组个数添加LetterLabel

```swift
// 获取数组个数
let count = CGFloat(self.brandList.count)
// 利用EnumerateSequence遍历可以获得带index的元组
        for (index,letter) in EnumerateSequence(self.brandList.map{ $0.letter! }) {
            // 设置letterLabelfram和字体颜色等 
            let letterLabel = UILabel(frame: CGRect(x: 0, y: indexViewH / count * CGFloat(index) , width: 12, height: indexViewH / count))
            letterLabel.font = UIFont.systemFontOfSize(12)
            letterLabel.textColor = QGColor.GrayColor
            letterLabel.text = letter
            indexView.addSubview(letterLabel)
        }
```
####3.给indexView添加手势
```swift
        let touch = UITapGestureRecognizer(target: self, action: "indexViewTap:")
        indexView.addGestureRecognizer(touch)
```
####4.通过手势让tableview滚动到指定的section
```swift
    // 手势响应的方法
    func indexViewTap(tap: UITapGestureRecognizer) {
        // 获得点击手势在indexview的坐标Y
        let touchY = tap.locationInView(indexView).y
        // 利用坐标Y获得一个索引也就是letterLabel在indexview的索引
        let index = Int(touchY / indexView.bounds.height * CGFloat(brandList.count))
        // 创建indexPath 让tableview滚动到该位置
        let indexPath = NSIndexPath(forRow: 0, inSection: index)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
```
