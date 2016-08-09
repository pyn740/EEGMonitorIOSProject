#EEGMonitorIOSProject

###整个工程主要包括：

- 具体实现各功能的Objective-C代码，完成整个iOS应用
- 应用中Monitor部分用到的unity实现代码，该程序专门为iOS端定制
- unity程序NIRSIT_EYE_iOSver_modi生成的iOS程序

###详细模块：

1. LoginAndRegister Module：主要包括医生和病人的登录注册模块，其中有5个Cocoa Touch Class，表3介绍使用的类的名称和它们各自的作用。

2. DeviceCalibration Module：主要用于实现此应用与头戴设备NIRSIT的校准问题，用于显示检测到的头戴设备信号是否正确。
3. Select Module 此部分用于Task、Monitor模式的选择，行为、认知任务的选择，起一个桥接的作用。

4. Monitor Module：此部分主要有两个类，一个是MainMonitorViewController类，其中集成了unity大脑图像，并完成了48个图表的并行绘制，另外一个是Speedometer类，用以实现最大信号值变速器。

5. BehaviorTask&CognitiveTask Modul：主要包括两个行为任务Balance，Squat和三个认知任务NBack，Arithmetic，Stroop，用于指导用户实施行为以监测脑电。

