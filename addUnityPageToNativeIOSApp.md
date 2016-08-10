
目录：

[TOC]




#**一  运行环境**
Unity 5.2.0f3
Xcode 7.0.1

#**二  Unity部分**
##**2.1  目的**
    创建一个简单的Unity应用，其中只有一个Cube，以便后续在ios应用的原生页面里放置Button, 点击Button旋转Cube
##**2.2  步骤**
 1. 在桌面/Users/admin/Desktop创建工程UnityProject (Ps: admin 是我的Mac名)
 
 2. 在生成的UnityProject->Assets中添加文件夹命名为Scripts，再在Scripts中添加move.js脚本
 
 3. 创建一个Cube，将move.js脚本绑定在Cube上
 4. 然后在生成的UnityProject->Assets中添加文件夹Plugins，接着在Plugins中添加文件夹iOS，然后在iOS中添加MyAppController.mm文件
 
 5. 配置Unity中的iOS选项：
  Edit->Project Setting->Player 进入Setting for iOS
![这里写图片描述](http://img.blog.csdn.net/20151023170353065)
  
  Allowed Orientation for Auto Rotation: 勾掉Potrait, Potrait Upside Down（使本应用只支持横屏）
  Auto Graphic API: 去掉勾，然后选择OpenGLES2
  Scripting Backend: IL2CPP
  Target Device: iPad only
  Target iOS Version: 8.0
  
 6. 导出Unity生成的iOS Project
  File->Build Settings 选择iOS，然后Build And Run。路径为/Users/admin/Desktop/UnityExportIOSProject
  
![这里写图片描述](http://img.blog.csdn.net/20151023171813084)


#**三  原生iOS应用部分**
1. Create a new Xcode project->Single View Application, 命名为MyProject， 放在桌面

2. Project->MyProject->Info, 将iOS Deployment Target设置为8.0

3. Target->MyProject->General, Device Orientaion 取消Portrait和Upside Down前面的勾

4. 保存

#**四  Unity和iOS的结合**
##**4.1 目的**
    目前我们的桌面上总共有三个文件夹：

![这里写图片描述](http://img.blog.csdn.net/20151023172747083)

    第一个是Unity工程，第二个是Unity导出的iOS工程，第三个就是我们自己的原生工程，接下来我们就会将UnityExportIOSProject整合到MyProject中

##**4.2  步骤**

1. 将UnityExportIOSProject中的文件夹Classes和Libraries拖动到MyProject中，不要勾选Copy items if needed

  ![这里写图片描述](http://img.blog.csdn.net/20151023173630807) 

2. Project->MyProject->Build Setting
    在Header search paths 添加：
    ${SOURCE_ROOT}/../UnityExoprtIOSProject/Classes

    ${SOURCE_ROOT}/../UnityExportIOSProject/Libraries/libil2cpp/include

    ${SOURCE_ROOT}/../UnityExportIOSProject/Libraries/bdwgc/include

    ${SOURCE_ROOT}/../UnityExportIOSProject/Classes/Native

    在Library Search Paths 添加：
    ${SOURCE_ROOT}/../UnityExportIOSProject/Libraries

    ${SOURCE_ROOT}/../UnityExportIOSProject/Libraries/Plugins/iOS

3. 将Classes中的main.mm文件的内容全部拷贝到Supporting Files中的main.m中，然后删除Classes中的main.mm文件，再将Supporting Files中的main.m文件重命名为main.mm

4. 在Supporting Files文件夹中创建新的PCH文件，命名为PrefixHeader，如下图所示勾选上Target，将Classes中的Prefix.pch文件的内容全部拷贝到Supporting Files中的PrefixHeader.pch中。
![这里写图片描述](http://img.blog.csdn.net/20151023180138405)

5. Project->MyProject->Build Setting
设置Precompile Prefix Header: YES
并在Prefix Header中添加：
${SOURCE_ROOT}/MyProject/PrefixHeader.pch

6. Target->MyProject->Build Phases
点击如下图所示左上角的“+”号，选择New Run Script Phase

![这里写图片描述](http://img.blog.csdn.net/20151023193513870)
往其中添加：

![这里写图片描述](http://img.blog.csdn.net/20151023193351099)
7. Target->MyProject->Build Phases->Link Binary With Libraries，添加如下

![这里写图片描述](http://img.blog.csdn.net/20151023181535829)
8.  Project->MyProject->Build Setting
在Other Linker Flags添加
-lc++
-weak_framework
CoreMotion
-weak-lSystem

在Other C Flags添加
-mno-thumb
-DINIT_SCRIPTING_BACKEND=1

设置 C Language Dialekt：C99[-std=c99]
设置 C++ Language Dialekt : C++ 11[-std=c++11]
设置 C++ Standard Library : libc++ (LLVM C++ standard Library with C++11 support)
设置 Enable Modules (C and Objective-C) : YES
设置 Enable Bitcode : NO
9.  Project->MyProject->Build Setting
点击如下图的“+”号，选择4个Add User-Defined Setting


![这里写图片描述](http://img.blog.csdn.net/20151023182715982)

设置key值：GCC_THUMB_SUPPORT，设置Value值：NO
设置key值：GCC_USE_INDIRECT_FUNCTION_CALLS，设置Value值：NO
设置key值：UNITY_RUNTIME_VERSION，设置Value值：5.2.0f3
设置key值：UNITY_SCRIPTING_BACKEND，设置Value值： il2cpp
10. 选择Info.plist
添加key值：Unity_LoadingActivityIndicatorStyle，设置Value值：-1
11. 新建一个CubeSceneViewController类，将CubeSceneViewController.m文件重命名为CubeSceneViewController.mm
在main.storyboard中如下图设置：

![这里写图片描述](http://img.blog.csdn.net/20151023190750486)

12.在CubeSceneViewController.h中添加

```
#import "UI/UnityView.h"
#import "UI/UnityViewControllerBase.h"
#include "UnityAppController+ViewHandling.h"

```

在CubeSceneViewController.mm的viewDidLoad中添加

```
GetAppController().unityView.frame = self.unityView.frame;
    
    // This adds the UnityView finally
    [self.unityView addSubview:(UIView*)GetAppController().unityView];
    [self.unityView setNeedsLayout];

```

并在CubeSceneViewController.mm添加：

```
- (IBAction)leftBtnClicked:(id)sender {
    
    UnitySendMessage("Cube","MoveLeft","");
}
- (IBAction)rightBtnClicked:(id)sender {
    UnitySendMessage("Cube","MoveRight","");
}
- (IBAction)upBtnClicked:(id)sender {
    UnitySendMessage("Cube","MoveUp","");
}
- (IBAction)downBtnClicked:(id)sender {
    UnitySendMessage("Cube","MoveDown","");
}

```

#**五  运行**
首页：
![这里写图片描述](http://img.blog.csdn.net/20151023191548603)
向左转：
![这里写图片描述](http://img.blog.csdn.net/20151023191612691)
向上转：
![这里写图片描述](http://img.blog.csdn.net/20151023191625541)


#**六  参考**
http://www.the-nerd.be/2014/09/08/sandbox-unity-app-in-existing-ios-app/
http://www.makethegame.net/unity/add-unity3d-to-native-ios-app-with-unity-5-and-vuforia-4-x/


