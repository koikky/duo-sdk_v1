# duo-sdk
A simple sdk for duo to build RT-Thread

## 准备工作
### 拉取duo-sdk
使用 ``` $ git clone git@github.com:koikky/duo-sdk.git ``` 可以拉取duo-sdk到本地目录

### 拉取rt-thread
使用 ``` $ git clone git@github.com:RT-Thread/rt-thread.git ``` 可以拉取RT-Thread源码到本地目录

### 检查
可以使用 ``` $ ls -l ``` 命令检查是否存在duo-sdk目录以及rt-thread目录

## 开始使用
### 加载环境
每次需要加载duo-sdk目录下的env.sh
例如可以使用 ``` $ source duo-sdk/env.sh duo256m std ```
其中，后面的参数是配置当前环境的，第一个参数是duo的型号，第二个参数是rt-thread的版本
同时，可以在终端里输入help获取更多信息。
例如 ``` $ help ```

### 配置
``` $ bone_menuconfig ``` 可以配置大核所使用的内核。
``` $ sone_menuconfig ``` 可以配置大核所使用的内核。

### 编译
``` $ make_bcore ``` 可以编译大核的代码。
``` $ make_score ``` 可以编译小核的代码。

### 打包（可选）
``` $ pack_image ``` 可以打包为一个img文件

##注意
输出目录在output/下
