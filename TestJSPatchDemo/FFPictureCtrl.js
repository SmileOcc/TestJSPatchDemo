
require('UIColor');

defineClass('FFPictureCtrl', {
            
            //块一
            init: function() {
            self = self.super().init()
            return self
            },
            
            dealloc: function() {
            console.log('js_delloc FFPictureCtrl');
            },
            
            
            viewDidLoad: function() {
            self.ORIGviewDidLoad();

            self._loadDataSource();
            self.collectionView().reloadData();
            
            self.collectionView().setFrame({x:0, y:0, width:self.view().bounds().width,height:self.view().bounds().height});
            
            },
            
            _loadDataSource: function() {
            console.log(' datas: ++++' + self.datas().toJS);

            var tempDatas = self.datas().toJS;
            if (tempDatas) return tempDatas;
            
            var tempDatas = [];
            for (var i = 0; i < 5; i ++) {
                tempDatas.push("datas js " + i);
            }
            self.setDatas(tempDatas);
            
            // OC中的数组输出问题？？？？
            console.log(' datas: ' + self.datas() + '\nd:' + tempDatas);


            //数组个数
            console.log('datas count:' + tempDatas.length + ':  ' + self.datas().count());

            },
            
            // MARK: -
            numberOfSectionsInCollectionView: function(collectionView) {
                return 1;
            },
            
            collectionView_numberOfItemsInSection: function(collectionView, section) {
            
                return self.datas().count();
            },
      
})
