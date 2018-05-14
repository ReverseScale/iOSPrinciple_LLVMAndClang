# iOSPrinciple_LLVMAndClang
Principle LLVM & Clang

### 一.相关概念

#### 历史原因

2000年，伊利诺伊大学厄巴纳－香槟分校（University of Illinois at Urbana-Champaign 简称UIUC）这所享有世界声望的一流公立研究型大学的 Chris Lattner（他的 twitter @clattner_llvm ） 开发了一个叫作 Low Level Virtual Machine 的编译器开发工具套件，后来涉及范围越来越大，可以用于常规编译器，JIT编译器，汇编器，调试器，静态分析工具等一系列跟编程语言相关的工作，于是就把简称 LLVM 这个简称作为了正式的名字。Chris Lattner 后来又开发了 Clang，使得 LLVM 直接挑战 GCC 的地位。2012年，LLVM 获得美国计算机学会 ACM 的软件系统大奖，和 UNIX，WWW，TCP/IP，Tex，JAVA 等齐名。

Chris Lattner 生于 1978 年，2005年加入苹果，将苹果使用的 GCC 全面转为 LLVM。2010年开始主导开发 Swift 语言。

iOS 开发中 Objective-C 是 Clang / LLVM 来编译的。

Swift 是 Swift / LLVM，其中 Swift 前端会多出 SIL optimizer，它会把 .swift 生成为中间代码 .sil 属于 High-Level IR， 因为 Swift 在编译时就完成了方法绑定，直接通过地址调用属于强类型语言，方法调用不再是像OC那样的消息发送，这样编译就可以获得更多的信息用在后面的后端优化上。

LLVM是一个模块化和可重用的编译器和工具链技术的集合，Clang 是 LLVM 的子项目，是 C，C++ 和 Objective-C 编译器，目的是提供惊人的快速编译，比 GCC 快3倍，其中的 clang static analyzer 主要是进行语法分析，语义分析和生成中间代码，当然这个过程会对代码进行检查，出错的和需要警告的会标注出来。LLVM 核心库提供一个优化器，对流行的 CPU 做代码生成支持。lld 是 Clang / LLVM 的内置链接器，clang 必须调用链接器来产生可执行文件。

这里是 Clang 官方详细文档： Welcome to Clang’s documentation! — Clang 4.0 documentation （http://clang.llvm.org/docs/）

这篇是对 LLVM 架构的一个概述： The Architecture of Open Source Applications（http://www.aosabook.org/en/llvm.html）

将编译器之前对于编译的前世今生也是需要了解的，比如回答下这个问题，编译器程序是用什么编译的？看看 《linkers and loaders》 这本书就知道了。（https://book.douban.com/subject/1436811/）

#### LLVM 与 Clang 介绍

LLVM 是 Low Level Virtual Machine 的简称，这个库提供了与编译器相关的支持，能够进行程序语言的编译期优化、链接优化、在线编译优化、代码生成。简而言之，可以作为多种语言编译器的后台来使用。如果这样还比较抽象的话，介绍下 Clang 就知道了：Clang 是一个 C++ 编写、基于 LLVM、发布于 LLVM BSD 许可证下的 C/C++/Objective C/Objective C++ 编译器，其目标（之一）就是超越 GCC。

Clang 开发事出有因，Wiki 介绍如下：
> Apple 使用 LLVM 在不支持全部 OpenGL 特性的 GPU (Intel 低端显卡) 上生成代码 (JIT)，令程序仍然能够正常运行。之后 LLVM 与 GCC 的集成过程引发了一些不快，GCC 系统庞大而笨重，而 Apple 大量使用的 Objective-C 在 GCC 中优先级很低。此外 GCC 作为一个纯粹的编译系统，与 IDE 配合很差。加之许可证方面的要求，Apple 无法使用修改版的 GCC 而闭源。于是 Apple 决定从零开始写 C family 的前端，也就是基于 LLVM 的 Clang 了。

Clang 的特性：

- 快：通过编译 OS X 上几乎包含了所有 C 头文件的 carbon.h 的测试，包括预处理 (Preprocess)，语法 (lex)，解析 (parse)，语义分析 (Semantic Analysis)，抽象语法树生成 (Abstract Syntax Tree) 的时间，Clang 是 Apple GCC 4.0 的 2.5x 快。(2007-7-25)
- 内存占用小：Clang 内存占用是源码的 130%，Apple GCC 则超过 10x。
- 诊断信息可读性强：我不会排版，推荐去网站观看。其中错误的语法不但有源码提示，还会在错误的调用和相关上下文的下方有~~~~~和^的提示，相比之下 GCC 的提示很天书。
- GCC 兼容性。
- 设计清晰简单，容易理解，易于扩展增强。与代码基础古老的 GCC 相比，学习曲线平缓。
- 基于库的模块化设计，易于 IDE 集成及其他用途的重用。由于历史原因，GCC 是一个单一的可执行程序编译器，其内部完成了从预处理到最后代码生成的全部过程，中间诸多信息都无法被其他程序重用。Clang 将编译过程分成彼此分离的几个阶段，AST 信息可序列化。通过库的支持，程序能够获取到 AST 级别的信息，将大大增强对于代码的操控能力。对于 IDE 而言，代码补全、重构是重要的功能，然而如果没有底层的支持，只使用 tags 分析或是正则表达式匹配是很难达成的。

当然，GCC 也有其优势：

- 支持 JAVA/ADA/FORTRAN
- 当前的 Clang 的 C++ 支持落后于 GCC，参见。（近日 Clang 已经可以自编译，见）
- GCC 支持更多平台
- GCC 更流行，广泛使用，支持完备
- GCC 基于 C，不需要 C++ 编译器即可编译

#### iOS 开发中用途

> 一般可以将编程语言分为两种，编译语言和直译式语言。

* 编译语言:像C++,Objective C都是编译语言。编译语言在执行的时候，必须先通过编译器生成机器码，机器码可以直接在CPU上执行，所以执行效率较高。
* 直译式语言:像JavaScript,Python都是直译式语言。直译式语言不需要经过编译的过程，而是在执行的时候通过一个中间的解释器将代码解释为CPU可以执行的代码。所以，较编译语言来说，直译式语言效率低一些，但是编写的更灵活，也就是为啥JS大法好。

iOS开发目前的常用语言是：Objective和Swift。二者都是编译语言，换句话说都是需要编译才能执行的。二者的编译都是依赖于Clang + LLVM.

*iOS编译*

不管是OC还是Swift，都是采用Clang作为编译器前端，LLVM(Low level vritual machine)作为编译器后端。所以简单的编译过程如图

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/20136923.jpg)

*编译器前端*

编译器前端的任务是进行：语法分析，语义分析，生成中间代码(intermediate representation )。在这个过程中，会进行类型检查，如果发现错误或者警告会标注出来在哪一行。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/51771760.jpg)

*编译器后端*

编译器后端会进行机器无关的代码优化，生成机器语言，并且进行机器相关的代码优化。iOS的编译过程，后端的处理如下

- LVVM优化器会进行BitCode的生成，链接期优化等等。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/14575808.jpg)

- LLVM机器码生成器会针对不同的架构，比如arm64等生成不同的机器码。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/65380951.jpg)

*执行一次 XCode build 的流程*

当你在XCode中，选择build的时候(快捷键command+B)，会执行如下过程

- 编译信息写入辅助文件，创建编译后的文件架构(name.app)
- 处理文件打包信息，例如在debug环境下

```
Entitlements:
{
   "application-identifier" = "app的bundleid";
   "aps-environment" = development;
}
```

- 执行CocoaPod编译前脚本(例如对于使用CocoaPod的工程会执行CheckPods Manifest.lock)
- 编译各个.m文件，使用CompileC和clang命令。

```
CompileC ClassName.o ClassName.m normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.compiler
export LANG=en_US.US-ASCII
export PATH="..."
clang -x objective-c -arch x86_64 -fmessage-length=0 -fobjc-arc... -Wno-missing-field-initializers ... -DDEBUG=1 ... -isysroot iPhoneSimulator10.1.sdk -fasm-blocks ... -I 上文提到的文件 -F 所需要的Framework  -iquote 所需要的Framework  ... -c ClassName.c -o ClassName.o
```

通过这个编译的命令，我们可以看到

- clang是实际的编译命令
- x objective-c 指定了编译的语言
- arch x86_64制定了编译的架构，类似还有arm7等
- fobjc-arc 一些列-f开头的，指定了采用arc等信息。这个也就是为什么你可以对单独的一个.m文件采用非ARC编程。
- Wno-missing-field-initializers 一系列以-W开头的，指的是编译的警告选项，通过这些你可以定制化编译选项
- DDEBUG=1 一些列-D开头的，指的是预编译宏，通过这些宏可以实现条件编译
- iPhoneSimulator10.1.sdk 制定了编译采用的iOS SDK版本
- I 把编译信息写入指定的辅助文件
- F 链接所需要的Framework
- c ClassName.c 编译文件
- o ClassName.o 编译产物

工作流程
- 链接需要的Framework，例如Foundation.framework,AFNetworking.framework,ALiPay.fframework
- 编译xib文件
- 拷贝xib，图片等资源文件到结果目录
- 编译ImageAssets
- 处理info.plist
- 执行CocoaPod脚本
- 拷贝Swift标准库
- 创建.app文件和对其签名

*dSYM 文件*

我们在每次编译过后，都会生成一个dsym文件。dsym文件中，存储了16进制的函数地址映射。

在App实际执行的二进制文件中，是通过地址来调用方法的。在App crash的时候，第三方工具(Fabric,友盟等)会帮我们抓到崩溃的调用栈，调用栈里会包含crash地址的调用信息。然后，通过dSYM文件，我们就可以由地址映射到具体的函数位置。

XCode中，选择Window -> Organizer可以看到我们生成的archier文件

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/37836378.jpg)

> iOS 如何调试第三方统计到的崩溃报告 (http://blog.csdn.net/hello_hwc/article/details/50036323)

*__attribute__*

或多或少，你都会在第三方库或者iOS的头文件中，见到过attribute。

比如

```
 __attribute__ ((warn_unused_result)) //如果没有使用返回值，编译的时候给出警告
```

__attribtue__ 是一个高级的的编译器指令，它允许开发者指定更更多的编译检查和一些高级的编译期优化。

分为三种：

- 函数属性 (Function Attribute)
- 类型属性 (Variable Attribute )
- 变量属性 (Type Attribute )

语法结构

__attribute__ 语法格式为：__attribute__ ((attribute-list))

放在声明分号“;”前面。

比如，在三方库中最常见的，声明一个属性或者方法在当前版本弃用了

```
@property (strong,nonatomic)CLASSNAME * property __deprecated;
```

这样的好处是：给开发者一个过渡的版本，让开发者知道这个属性被弃用了，应当使用最新的API，但是被__deprecated的属性仍然可以正常使用。如果直接弃用，会导致开发者在更新Pod的时候，代码无法运行了。

__attribtue__的使用场景很多，本文只列举iOS开发中常用的几个：

```
//弃用API，用作API更新
#define __deprecated    __attribute__((deprecated))

//带描述信息的弃用
#define __deprecated_msg(_msg) __attribute__((deprecated(_msg)))

//遇到__unavailable的变量/方法，编译器直接抛出Error
#define __unavailable   __attribute__((unavailable))

//告诉编译器，即使这个变量/方法 没被使用，也不要抛出警告
#define __unused    __attribute__((unused))

//和__unused相反
#define __used      __attribute__((used))

//如果不使用方法的返回值，进行警告
#define __result_use_check __attribute__((__warn_unused_result__))

//OC方法在Swift中不可用
#define __swift_unavailable(_msg)   __attribute__((__availability__(swift, unavailable, message=_msg)))
```

*Clang警告处理*

你一定还见过如下代码：

```
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
///代码
#pragma clang diagnostic pop
```

这段代码的作用是

- 对当前编译环境进行压栈
- 忽略-Wundeclared-selector(未声明的)Selector警告
- 编译代码
- 对编译环境进行出栈

通过clang diagnostic push/pop,你可以灵活的控制代码块的编译选项。

> - iOS 合理利用Clang警告来提高代码质量 (http://blog.csdn.net/Hello_Hwc/article/details/46425503)

*预处理*

所谓预处理，就是在编译之前的处理。预处理能够让你定义编译器变量，实现条件编译。

比如，这样的代码很常见

```
#ifdef DEBUG
//...
#else
//...
#endif
```

同样，我们同样也可以定义其他预处理变量,在XCode-选中Target-build settings中，搜索proprecess。然后点击图中蓝色的加号，可以分别为debug和release两种模式设置预处理宏。

比如我们加上：TestServer，表示在这个宏中的代码运行在测试服务器

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/76261869.jpg)

然后，配合多个Target(右键Target，选择Duplicate)，单独一个Target负责测试服务器。这样我们就不用每次切换测试服务器都要修改代码了。

```
#ifdef TESTMODE
//测试服务器相关的代码
#else
//生产服务器相关代码
#endif
```

*插入脚本*

通常，如果你使用CocoaPod来管理三方库，那么你的Build Phase是这样子的：

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/95073964.jpg)

其中：[CP]开头的，就是CocoaPod插入的脚本。

- Check Pods Manifest.lock，用来检查cocoapod管理的三方库是否需要更新
- Embed Pods Framework，运行脚本来链接三方库的静态/动态库
- Copy Pods Resources，运行脚本来拷贝三方库的资源文件

而这些配置信息都存储在这个文件(.xcodeprog)里

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/26813964.jpg)

到这里，CocoaPod的原理也就大致搞清楚了，通过修改xcodeproject，然后配置编译期脚本，来保证三方库能够正确的编译连接。

同样，我们也可以插入自己的脚本，来做一些额外的事情。比如，每次进行archive的时候，我们都必须手动调整target的build版本，如果一不小心，就会忘记。这个过程，我们可以通过插入脚本自动化。

```
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${INFOPLIST_FILE}"
```

这段脚本其实很简单，读取当前pist的build版本号,然后对其加一，重新写入。

使用起来也很简单：

- Xcode – 选中Target – 选中build phase
- 选择添加Run Script Phase

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/35075756.jpg)

然后把这段脚本拷贝进去，并且勾选Run Script Only When installing，保证只有我们在安装到设备上的时候，才会执行这段脚本。重命名脚本的名字为Auto Increase build number

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/35590469.jpg)

然后，拖动这个脚本的到Link Binary With Libraries下面

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/39616731.jpg)

*脚本编译打包*

脚本化编译打包对于CI(持续集成)来说，十分有用。iOS开发中，编译打包必备的两个命令是：

```
//编译成.app
xcodebuild  -workspace $projectName.xcworkspace -scheme $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
//打包
xcrun -sdk iphoneos PackageApplication -v $appDir/$projectName.app -o $appDir/$ipaName.ipa

通过info命令，可以查看到详细的文档
info xcodebuild
```

> 之前写的一套基于 Python 的编译打包脚本 (https://github.com/ReverseScale/AutoBuildScript/blob/master/autobuild.py)

*提高项目编译速度*

通常，当项目很大，源代码和三方库引入很多的时候，我们会发现编译的速度很慢。在了解了XCode的编译过程后，我们可以从以下角度来优化编译速度：

1)查看编译时间

我们需要一个途径，能够看到编译的时间，这样才能有个对比，知道我们的优化究竟有没有效果。

对于XCode 8，关闭XCode，终端输入以下指令

```
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
```

然后，重启XCode，然后编译，你会在这里看到编译时间。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/18054177.jpg)

2)代码层面的优化

2.1)forward declaration

所谓forward declaration，就是@class CLASSNAME，而不是#import CLASSNAME.h。这样，编译器能大大提高#import的替换速度。

2.2)对常用的工具类进行打包(Framework/.a)

打包成Framework或者静态库，这样编译的时候这部分代码就不需要重新编译了。

2.3)常用头文件放到预编译文件里

XCode的pch文件是预编译文件，这里的内容在执行XCode build之前就已经被预编译，并且引入到每一个.m文件里了。

3)编译器选项优化
3.1)Debug模式下，不生成dsym文件

上文提到了，dysm文件里存储了调试信息，在Debug模式下，我们可以借助XCode和LLDB进行调试。所以，不需要生成额外的dsym文件来降低编译速度。

3.2)Debug开启Build Active Architecture Only

在XCode -> Build Settings -> Build Active Architecture Only 改为YES。这样做，可以只编译当前的版本，比如arm7/arm64等等，记得只开启Debug模式。这个选项在高版本的XCode中自动开启了。

3.3)Debug模式下，关闭编译器优化

编译器优化

![](http://og1yl0w9z.bkt.clouddn.com/18-5-14/34559597.jpg)

#### 更多深入学习
关于 iOS 编译 Clang LLVM 相关的知识整理参见：

https://github.com/ming1016/study/wiki/深入剖析-iOS-编译-Clang---LLVM


> 以上原理解析文章来源：https://my.oschina.net/u/2345393/blog/820141，https://linuxtoy.org/archives/llvm-and-clang.html，https://blog.csdn.net/hello_hwc/article/details/53557308，https://github.com/ming1016/study/wiki/深入剖析-iOS-编译-Clang---LLVM
