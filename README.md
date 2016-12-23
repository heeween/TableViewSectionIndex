#### TableViewSectionIndex
####解决tableviewSectionindex不能平均的问题
####1.如何使用

```swift
        self.tableView.yw_index = YWIndexView.IndexViewWith(sectionTitles: self.listArray.map{ $0.letter! })!
```

####2.如何集成到项目中

直接把UITableView+Additions.swift拖入项目中即可
系统中的index界面
![系统中有index的tableview](http://upload-images.jianshu.io/upload_images/661867-bbbd2c97a5fe146c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设计师的要求的界面
![设计图中有index的tableview](http://upload-images.jianshu.io/upload_images/661867-390778aa2fc11a78.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

于是我开始了百度 google stackOverFlow...都没有找到合适的方法.StackOverFlow上的解决方法是给每一个字符后添加一个空字符,注意是数组中的元素后.这也数组长度变大,这样indexTitle中间插入一些空格索引.看起来是变长了,但是需要在返回section高度和返回sectionview以及返回section和index关联三个代理方法中分别设置对于空字符的处理.较为麻烦 而且布局也不够美观.详见[[StackOverFlow]--UITableView section index spacing on iOS 7](http://stackoverflow.com/questions/18923729/uitableview-section-index-spacing-on-ios-7)
另外也有国内开发者对这篇文章的翻译见[[4byte.cn]--在iOS 7表格部分指标间距](http://www.4byte.cn/question/481261/uitableview-section-index-spacing-on-ios-7.html)

下面介绍我的方法,先介绍下整体思路.我是自定义一个indexview放在控制器上.创建多个letterLabel放在indexview上.每个letterLabel高度为indexview的高度除以数组的个数,这样就能保证indexview的高度更加填充慢屏幕.通过给indexview添加一个tap手势,再通过手势的位置算索引indexPath,然后让tableview滚动到对应的索引.



