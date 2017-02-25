


require('UIScreen, UIView, UIButton, UIColor, UILabel, UIFont, UIImageView, UIImage,NSString')
require('FFEasyLifePictureCtrl')
require('FFPictureCtrl')
require('YSAlertView')
require('FFTestObject')
require('NSMutableParagraphStyle,NSAttributedString,NSURL')

/**
内存释放问题:
如果一个 OC 对象被 JS 引用，或者在 JS 创建这个对象，这个 OC 对象在退出作用域后不会马上释放，而是会等到 JS 垃圾回收时才释放，这会导致一些 OC 对象延迟释放：
*/

/**
dealloc 问题: 
 可以用 JSPatch 为类添加 dealloc 方法，但无法覆盖原 OC 上的 dealloc 方法，在执行完 JS 的 dealloc 后会自动执行 OC 上的 dealloc 方法，因为若不执行 OC 的 dealloc 方法，对象无法正常释放，会产生内存泄漏：
*/


//若宏的值是某些在底层才能获取到的值，例如 CGFLOAT_MIN，可以通过在某个类或实例方法里将它返回，或者用添加扩展的方式提供支持：
require('JPEngine').addExtensions(['FFMacroSupport'])

var floatMin = CGFLOAT_MIN();


require('JPEngine').addExtensions(['JPMemory'])



//Objective-C 里的宏同样不能直接在 JS 上使用。若定义的宏是一个值，可以在 JS 定义同样的全局变量代替，若定义的宏是程序，可以在JS展开宏
//JSPatch 不支持修改宏的值，若要修改，需要替换所有使用到这个宏的方法
var K_SCREEN_HEIGHT = UIScreen.mainScreen().bounds().height;
var K_SCREEN_WIDTH = UIScreen.mainScreen().bounds().width;



//在类里定义的 static 全局变量无法在 JS 上获取到，若要在 JS 拿到这个变量，需要在 OC 有类方法或实例方法把
var staticName = FFTestObject.staticName();

console.log('UIScreen_Height: ' + K_SCREEN_HEIGHT);
console.log('floatMin: ' + floatMin);
console.log('staticName: ' + staticName);

defineClass('FFEasyLifeHomeCtrl',['data','nameArray','totalCount'], {
            
            viewWillAppear:function(animated) {
            self.super().viewWillAppear(animated);
            //self.catButton().setEnable(NO);
            },
            
            viewWillDisappear: function(animated) {
            self.super().viewWillDisappear(animated);
            //
            },
            

            viewDidLoad: function() {
            self.ORIGviewDidLoad();
            
            self.navigationItem().setTitle(">首页<");
            
            //传递 id* 参数
            /**

             这里传入的是一个指向 NSObject 对象的指针，在方法里可以修改这个指针指向的对象，调用后外部可以拿到新指向的对象，对于这样的参数，需要按以下步骤进行传递和获取：
             
             使用 malloc(sizeof(id)) 创建一个指针
             把指针作为参数传给方法
             方法调用完，使用 pval() 拿到指针新指向的对象
             使用完后调用 releaseTmpObj() 释放这个对象
             使用 free() 释放指针
             */
            var pError = malloc(sizeof(1024));
            self.testPointer(pError);
            var error = pval(pError);
            if(!error) {
            console.log("success");
            } else {
            console.log('id_error: ' + error);
            }
            
            releaseTmpObj(pError);
            free(pError);

            
            self.performSelector_withObject_afterDelay("jsTestNumber", null, 2);
            
            
            // ============================= GCD ============================== //
            
            dispatch_after(1.0, function() {
                           console.log("GCD_after");
                           });
            
            dispatch_async_main(function() {
                                console.log("GCD_async_main");
                                });
            
            dispatch_sync_main(function() {
                               
                               });
            
            dispatch_async_global_queue(function() {
                                        
                                        });
            
            // ============================= NSNumber =========================== //
            //NSNumber 与上述四个类型不一样，所有数值类型以及 NSNumber 对象到 JS 后都会变成数值，不能再调用这个数值的任何方法：

            var ocNum = self.testObject().number();  //2
            var ocInt = self.testObject().age();  //2
            var jsNum = 2;
            
            //以上三个变量是相等的：
            console.log('NSNumber:');
            console.log(ocInt == ocInt); //true
            
            //不能调用 NSNumber 方法：
            //numFromOC.isEqualToNumber(2);  //crash
            
            // ============================= NSString =========================== //
            
            

            // ============================= 新增属性 ============================== //

            self.setProp_forKey("testPropertyValue", "testProperty");
            var testPro = self.getProp("testProperty");
            
            var  t = "dddddd";
            // 输出字符 ？？？？？
            console.log('getProp testPro : ' + testPro + '  t:' + t);
            
            
            
            // 使用 valueForKey() 和 setValue_forKey() 获取/修改私有成员变量:
            var data = self.valueForKey("_oneArrays");
            self.setValue_forKey([testPro,"JSPatch","JSPatch2"], "_oneArrays");
            console.log('oneArray: ' + data);
            
            
            //在 JSPatch 中不能将 Objective-C 中的 NSArray, NSString, NSDictionary 与 JavaScript 的 Array, String, Object 进行混用。
            
            var two2 = self.twoArrays();
            var two22 = ["two1","two2","two3"];
            var wrongStr = two2[0] //得到的是一个不正确的对象，请不要使用取下标的方式获取NSArray/NSDictionar对象。
            var rightStr = two2.toJS()[0] //先unbox返回的对象，然后取出其中的数据
            var rightStr2 = two2.objectAtIndex(0) //使用Objective-C方法获取NSArray/NSDictionary中的对象
            console.log('rightStr: ' + rightStr + '  rightstr2: ' + rightStr2);
            
            
            //如果是要获取含有双（或更多）下划线的property(这种情况比带有双下划线的方法更为常见一些)，可以使用 KVC 的 valueForKey 方法
            var testTwoLineStr = self.valueForKey("__testTwoLineString");
            //不能这样设置值
            //testTwoLineStr = "__testTwoLineString_js";
            //用KVC设置
            self.setValue_forKey("__testTwoLineString_js", "__testTwoLineString");
            //self.setValue_forKey(testTwoLineStr + "js", "__testTwoLineString"); ?????
            console.log('__testTwoLineString: ' + testTwoLineStr);
            
            
            
            //JS 上的 null 和 undefined 都代表 OC 的 nil，如果要表示 NSNull, 用 nsnull 代替，如果要表示 NULL, 也用 null 代替:
            console.log(require('FFTestObject').testNull(nsnull))   // return 1
            console.log(require('FFTestObject').testNull(null))     // return 0
            
            
            // ============================= block =========================== //
            //当要把 JS 函数作为 block 参数给 OC时，需要先使用 block(paramTypes, function) 接口包装
            require('FFTestObject').request(block("NSString *, BOOL", function(ctn,succ){
                                                  if (succ){
                                                  console.log(ctn)
                                                  }
                                                  }))
            
            //从 OC 返回给 JS 的 block 会自动转为 JS function，直接调用即可
            var blk = require('FFTestObject').genBlock();
            blk({v:"0.0.1"});
            require('FFTestObject').execBlock(block("id",blk));
            
            //在 block 里无法使用 self 变量，需要在进入 block 之前使用临时变量保存它:
            var slf = self;
            require('FFTestObject').request(block("NSString *, BOOL", function(ctn,succ){
                                                  slf.doSomething("self_block");
                                                  }))
            
            /**
             从 JS 传 block 到 OC，有两个限制：
             A. block 参数个数最多支持6个。（若需要支持更多，可以修改源码）
             B. block 参数类型不能是 double / NSBlock / struct 类型。
             另外不支持 JS 封装的 block 传到 OC 再传回 JS 去调用（原因见 issue #155）：
             */
            
            
            //可以在 JS 通过 __weak() 声明一个 weak 变量，主要用于避免循环引用,若要在使用 weakSelf 时把它变成 strong 变量，可以用 __strong() 接口
            var weakSelf = __weak(self);
            require('FFTestObject').request(block("NSString *, BOOL", function(ctn,succ){
                                                  var strongSelf = __strong(weakSelf);
                                                  weakSelf.doSomething("weakSelf_block");
                                                  }))
            
            
            
            // ============================= UIButton =========================== //
            
            //Objective-C 里的常量/枚举不能直接在 JS 上使用，可以直接在 JS 上用具体值代替
            //UIControlEventTouchUpInside的值是1<<6
            self.twoButton().titleLabel().setFont(UIFont.systemFontOfSize(11));
            self.twoButton().addTarget_action_forControlEvents(self,"doSomething:",1<<6);
            
            var jsButton =  UIButton.buttonWithType(0);
            jsButton.titleLabel().setFont(UIFont.systemFontOfSize(11));
            jsButton.setBackgroundColor(UIColor.orangeColor());
            jsButton.setTitle_forState("jsButton->约束",0);
            jsButton.addTarget_action_forControlEvents(self,"doSomething:",1<<6);
            self.view().addSubview(jsButton);
            
            jsButton.mas__remakeConstraints(block('MASConstraintMaker*', function(make) {
                                                  make.top().equalTo()(self.twoButton().mas__top());
                                                  make.left().equalTo()(self.twoButton().mas__right()).offset()(10);
                                                  make.width().equalTo()(100);
                                                  make.height().equalTo()(30);
                                                  }));
            
            
            // ============================= UILabel =========================== //
            
            self.titleLab().setBackgroundColor(UIColor.lightGrayColor());
            self.titleLab().setTextAlignment(1);
            self.titleLab().setFont(UIFont.systemFontOfSize(13));
            self.titleLab().setTextColor(UIColor.redColor());
            self.titleLab().setText("-首页 --");
            self.titleLab().setText(NSString.stringWithFormat("a:%@,b:%@","name",12));

            var jsParagraphStyle = NSMutableParagraphStyle.alloc().init();
            jsParagraphStyle.setLineSpacing(5);
            jsParagraphStyle.setAlignment(3);
            jsParagraphStyle.setLineBreakMode(0);
            var jsAttributes = {
            NSFont:UIFont.systemFontOfSize(20),
            NSParagraphStyle:jsParagraphStyle,
            NSColor:UIColor.redColor()
            };
            
            var jsAttributesString = NSAttributedString.alloc().initWithString_attributes("我就是", jsAttributes);
            self.oneLab().setAttributedText(jsAttributesString);
            
            var jsLabelOne = UILabel.alloc().initWithFrame({x: 0,y: self.titleLab().frame().y + self.titleLab().bounds().height,width: 80,height: 30});
            jsLabelOne.setText("橘色.");
            jsLabelOne.setBackgroundColor(UIColor.grayColor());
            jsLabelOne.setTextAlignment(2);
            self.view().addSubview(jsLabelOne);
            
            
            // ============================= UIImageView =========================== //

            self.recordImageView().setFrame({x:0, y:0, width:self.view().bounds().width, height:self.view().bounds().height - 64});
            self.recordImageView().layer().setCornerRadius(10);
            self.recordImageView().layer().setBorderColor(UIColor.yellowColor().CGColor());
            self.recordImageView().layer().setBorderWidth(1);
            self.recordImageView().layer().setMasksToBounds(YES);
            self.recordImageView().setHidden(NO);

            self.recordImageView().sd__setImageWithURL_placeholderImage(NSURL.URLWithString("http://upload-images.jianshu.io/upload_images/45741-56d638fd0b9c7926.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240/format/jpg"), UIImage.imageNamed("1.jpeg"));


            
            // ============================= UIView =========================== //
            //添加新view
            var jsView = UIView.alloc().initWithFrame({x: self.view().bounds().width - 100, y: 100, width: 40, height: 40});
            jsView.setBackgroundColor(UIColor.purpleColor());
            self.view().addSubview(jsView);

            jsView.mas__remakeConstraints(block('MASConstraintMaker*', function(make) {
                                                  make.top().equalTo()(self.titleLab().mas__bottom()).offset();
                                                  make.right().equalTo()(self.titleLab());
                                                  make.width().equalTo()(80);
                                                  make.height().equalTo()(30);
                                                  
                                                  }));
            
            },
            
            
            
            doSomething: function(content) {
            console.log('do something ' + content)
            },
            
            
            
            
            testObjectEvent: function() {
            var ocStr = self.testObject().name();
            var ocInfo = self.testObject().info();
            var occUsers = self.testObject().users();
            
            //给oc中对象赋值
            self.testObject().setName("testObject_js_name");
            
            //以上三个是从 OC 返回的 OC 对象，可以调用 OC 方法：
            var range = ocStr.rangeOfString("I'm");   //OK
            var tempInfo = ocInfo.addObject_forKey("a", "b");   //OK
            var firstObj = occUsers.firstObject();    //OK
            
            
            console.log('range:  ' + range + '\ninfo: ' + tempInfo + '\nfirstobj: ' + firstObj);
            
            
            ///////////////////////////////////////
            
            //            var str = "I'm JS String";
            //            var info = @{"k": "v"};
            //            var users = ["alex", "bang", "cat"];
            //            
            //            //以上三个是 JS 对象，不能调用 OC 方法：
            //            str.rangeOfString("I'm");   //crash
            //            str.addObject_forKey("a", "b");   //crash
            //            str.firstObject();    //crash
            
            //若要用JS语法操作这些类型，要确保它是 JS 对象。
            //错误：ocStr 不是 JS 对象，不能用 JS 语法拼接字符串
            //var newStr = ocStr + "js string";
            
            //正确：已用 .toJS() 接口转为 JS 对象，可以用 JS语法操作
            var transStr = ocStr.toJS();
            var newStr = transStr + " _js_string";
            console.log('\nnewStr:  ' + newStr);

            
            //错误：occUsers 不是 JS 对象，不能用[]语法，也不能用 JS 语法遍历
            //var firstUser = ocUser[0];
            //for (var i = 0; i < ocUsers.length; i ++) {
            //var user = ocUsers[i];
            //}
            
            
            //正确：已用 .toJS() 接口转为 JS 对象，可以用 JS语法操作
            var transArr = occUsers.toJS();
            for (var i = 0; i < transArr.length; i ++) {
            var user = transArr[i];
            console.log('\nuser:  ' + user);
            }
            },
            
            
            
            
            //如果调用的方法含有一个下划线，就需要使用双下划线来表示
            p__testLineFunction: function() {
            self.ORIGp__testLineFunction();
            self.setTestResultString(self.testResultString().stringByAppendingString("p_testLine_js"));
            console.log('p_testLineFunction: ')
            },
            
            __testLineFuntcionTwo: function() {
            self.ORIG__testLineFuntcionTwo();
            self.setTestResultString(self.testResultString().stringByAppendingString("_testLine_js"));
            console.log('_testLineFuntcionTwo: ');
            },
            
            
            jsTestNumber: function() {
            console.log('延迟调用');
            },
            
            
            
            
            testArray: function() {//测试数组越界
            var nameArrays = self.nameArrays().toJS();
            var testName = nameArrays[4];
            console.log('----- testName: ' + testName);
            
            //注意：建议不要使用for...in来遍历数组，
            for (var o in nameArrays) {
            console.log(o); //输出 0, 1，表示遍历数组的序号
            console.log(nameArrays[o]); //输出 name age，这样才表示数组的值
            }
            },
            
            testLable: function() {//UILable 相关设置
            
            //在方法名前加 ORIG 即可调用未覆盖前的 OC 原方法:
            self.ORIGtestLable();   //保留原先的代码;
            },
            
            testView: function() {

            },
            
            testButton: function() {
            
            self.catButton().setFrame({
                                      x:K_SCREEN_WIDTH / 4.0 ,
                                      y:self.view().bounds().height - 49,
                                      width:K_SCREEN_WIDTH / 4.0,
                                      height:49});
            self.catButton().setTitle_forState(">美图<", 0);
            },
            
            actionPicture: function(button) {
            var ctrl = FFEasyLifePictureCtrl.alloc().init();
            ctrl.view().setBackgroundColor(UIColor.lightGrayColor());
            self.navigationController().pushViewController_animated(ctrl, YES);
            },
            
            
            
            actionImg: function(button) {
            
            self.ORIGactionImg(button);

            // MARK: - 弹窗
            var tempAlertView = YSAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("提示","图片列表",self,"CANCEL","OK", null);
            tempAlertView.show(self.view());
            },
            
            // MARK: - YSAlertView delegate  怎么在js中加自定义delegate  ?????
            alertYSView_clickedButtonAtIndex(alertView,buttonIndex) {
            
            if (buttonIndex == 1) {
                var pictureCtrl = require('FFPictureCtrl').alloc().init();
            self.navigationController().pushViewController_animated(pictureCtrl, YES);
                }
            },
            
            actionOneButton: function(button) {
            var tempAlertView = YSAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("提示","js实现方法",null,"CANCEL","OK", null);
            tempAlertView.show(self.view());

            },
            
            
            testEvent: function() {
            
            //添加新的 Property (id data)
            //数组
            var nameArray = self.nameArray();
            if (nameArray) return nameArray;
            
            var nameArray = ['a','b'];
            self.setNameArray(nameArray);
            
            // 数组2
            var data = self.data();
            if (data) return data;
            
            var data = [];
            for (var i = 0; i < 20; i ++) {
                data.push("cell  " + i);
            }
            
            self.setData(data)
            

            
            self.setTotalCount(2)

            console.log('data count:' + data.length + ':  ' + self.data().length);
            console.log('data:'  + self.data());
            console.log('nameArray:'  + self.nameArray() + '\n' + 'totalCount:' + self.totalCount());
            console.log('随机数: ' + Math.random()*255)

            }
        
});


defineClass('FFTestDeadlock', {
    //JSPatch 新增了 .performSelectorInOC(selector, arguments, callback) 接口，可以在执行 OC 方法时脱离 JavaScriptCore 的锁，同时又保证程序顺序执行
    //若需要多次使用 .performSelectorInOC() 接口，可以无限嵌套
            
            
    //A线程：加X锁 ---> 进JS（等B释放JS锁）
    //B线程：进JS（JS加锁）---->调methodB（等A释放X锁）
    /**
    methodA: function() {
    self.methodB()   //调用到OC，
    },
     */
      
            
    //A线程：加X锁 ---> 进JS ----> 退JS -----> 释放X锁
    //B线程：进JS ----> 退JS -----> 调methodB（等A释放X锁）----> 获得X锁执行
    methodA: function() {
    return self.performSelectorInOC('methodB', [], function(ret){});
    },
})
