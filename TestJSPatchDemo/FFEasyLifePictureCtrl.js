/**
 Math.random() ----> 随机数
 console.log('打印输出') ----> 调试输出
 
 
 */

/**
 defineClass ------->
 defineClass(classDeclaration, [properties,] instanceMethods, classMethods)
 
 @param classDeclaration: 字符串，类名/父类名和Protocol
 @param properties: 新增property，字符串数组，可省略
 @param instanceMethods: 要添加或覆盖的实例方法
 @param classMethods: 要添加或覆盖的类方法
 
 */


require('UIColor');

defineClass('FFEasyLifePictureCtrl : UITableViewController <UIAlertViewDelegate>', ['data'], {
            
            //块一
            init: function() {
                self = self.super().init()
                return self
            },
            
            viewDidLoad: function() {
            },
            
            dataSource: function() {
            
                //数组
                var data = self.data();
                if (data) return data;
            
                var data = [];
                for (var i = 0; i < 20; i ++) {
                    data.push("cell from js " + i);
                }
            
                self.setData(data)
            
                console.log('data:'  + self.data());

                return data;
            },
            
            //块二
            // MARK: - tableDelegate
            numberOfSectionsInTableView: function(tableView) {
                return 1;
            },
            
            tableView_numberOfRowsInSection: function(tableView, section) {
                return self.dataSource().length;
            },
            
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
                return 200;
            },
            
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
                var cell = tableView.dequeueReusableCellWithIdentifier("cell")
                if (!cell) {
                    cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
                }
                cell.textLabel().setText(self.dataSource()[indexPath.row()])
                cell.setBackgroundColor(UIColor.colorWithRed_green_blue_alpha((Math.random() *255) / 255.0, (Math.random() *255) / 255.0, (Math.random() *255) / 255.0, 1));

            
                return cell
            },
            
            
            //块三
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            
                //弹窗
                var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
                alertView.show()
            },
            
            alertView_willDismissWithButtonIndex: function(alertView, idx) {
                console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
            }
})
