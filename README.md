# 黑苹果 Ozmosis for 华南 X79 V2.4X

English Version is [not ready](https://github.com/cheneyveron/ozmosis-huanan-x79-e5-2670/blob/master/docs/README.md).

国内同步镜像：https://gitee.com/cheneyveron/ozmosis-huanan-x79-e5-2670

## 资助

俺花费了一些时间和精力在上面，如果此项目帮助到了您，欢迎来资助我继续完善它。资助名单在最下方。

注意：这不是有偿协助，俺的时间非常有限，遇到问题请尽量提交issues，自己摸索。


Paypal : [paypal.me/cheneyveron](https://paypal.me/cheneyveron)

![支付宝与微信支付](https://github.com/cheneyveron/clover-x79-e5-2670-gtx650/blob/master/docs/IMG_0112.jpg)

## 变更记录:

2018/2/20: BIOS制作完成;

# 1 食用说明:

### 强烈建议先使用Clover配置好可启动的系统后，再尝试Ozmosis！

### !!!!!危险警告!!!!!

这三个BIOS ROM均会锁定CPU访问区域，导致刷新后无法通过fpt等软件的方式再刷其他ROM，可能会因此失去保修！

所以请**务必先买好编程器**！

### iiiii警告完毕iiiii

## 1.1 主板: 华南 X79 V2

主板版本 2.46

**BIOS版本 2.47**

BIOS ROM型号：EN25F64

可用的编程器：CH341A 24 25

某宝上可以在20元以下买到以上部件，别被骗了。

### 1.1.1 我能不能刷BIOS？

如果你满足下面的条件：

- 华南金牌主板（418块钱左右的）
- ATX版型（大版型）
- 蓝色内存插槽

那么你可以刷新BIOS。

**其他主板请勿刷！**

#### 1.1.1.1 我的CPU是xxx，显卡是xxx，可以刷吗?

可以。BIOS只与主板有关，与CPU、显卡、键鼠无关。

#### 1.1.1.2 刷了之后还能装Windows/Linux吗?

可以。俺把DSDT中的USB命名/CPU部分/显卡命名规范了一下。

## 1.2 Ozmosis 说明：

Ozmosis 会在刷好ROM第一次开机时，或者NVRAM被清空后，在它识别出的第一块硬盘的`ESP`分区中创建`EFI/Oz`文件夹。

只要你不改变主板上的硬盘位置，那么它所识别的“第一块硬盘”是固定的。

### 文件夹结构：

- `EFI/Oz/Acpi/Load/`：类似于Clover的`acpi/patched`，用于放置修改后的`DSDT.aml`和`SSDT.aml`。
- `EFI/Oz/Darwin/Extensions/common/`：类似于Clover的`kexts/other`，用于放置`.kext`格式的驱动。

驱动也可以转换成`.ffs`格式，直接插入ROM中。

### 常用开机快捷键：

- `ESC`：跳过加载Ozmosis模块。
- `Option`：进入Ozmosis的系统选择菜单。
- `Option + Command + P + R`：重置NVRAM并重新加载Ozmosis模块。
- `Delete`：进入 BIOS 设置。
- `Command + v`：啰嗦模式，相当于boot args中添加 -v 参数。
- `Command + x`：安全模式，相当于boot args中添加 -x 参数。

注：PC键盘中，`Command键`对应`Windows徽标键`。`Option键`对应`Alt键`。

## 1.3 刷新BIOS

因为处理器涉及到加载不同的SSDT，所以分以下两种情况。

### 1.3.1 对于 E5-2670 v1 C2：

1. 选择`x7947_ozm_e5_2670.fd`。

2. 找到Ozmosis自动创建的`EFI/Oz`文件夹，然后将本Repo中的`EFI`覆盖它创建的`EFI`。

如此，直接进系统/安装系统，处理器频率会锁定在2.6GHz或者1.2GHz。

3. 转 1.3.3 步骤。

### 1.3.2 对于非 E5-2670 V1：

1. 选择`x7947_ozm_all_cpu.fd`。

2. 找到Ozmosis自动创建的`EFI/Oz`文件夹，然后将本Repo中的`EFI`覆盖它创建的`EFI`。

3. 将自己处理器的`SSDT.aml`放入`EFI/Oz/Acpi/dump/`中。

4. 将处理器对应的`VoodooTSCSync.kext`放入`EFI/Oz/Darwin/Extensions/common`中。

在`Tools/SSDT-1`中我搜集了一些SSDT，它们未必能用，如果运气不好的话你就需要自己用`ssdtGen.sh`来生成了。

5. 转 1.3.3 步骤。

### 1.3.3 通过UEFI SHELL加载kernextpatcher.efi：

不知为何，我将kernextpatcher插入ROM后就无法打补丁，而通过UEFI SHELL加载后就行了。还望朋友们多多尝试。

启动 Clover，选择 Clover X64 UEFI Shell。然后输入以下命令：

1. `fs0:` 进入第一块硬盘的EFI分区。
2. `cd EFI` 进入EFI目录
3. `ls` 列出目录
4. `bcfg driver add 0 KernextPatcher.efi "KernextPatcher"` 加载KernextPatcher.efi为0号模块。
5. `bcfg driver dump` 列出当前加载的模块，确认有`KernextPatcher`模块。

如果想删除已经加载的模块，执行`bcfg driver rm 0`就可以删除0号模块了。

这样就大功告成了，全新安装系统后即可享受9档变频 ( 1.2 / 1.6 / 1.9 / 2.3 / 2.6 / 3.0 / 3.1 / 3.2 / 3.3 )。

聪明的你应该已经发现了，加载`kernextpatcher.efi`以后，就实现了全功能的Clover的`KextsToPatch`功能。只需要修改`EFI/KernextPatcher.plist`即可。

## 1.4 ROM变更

### 在 x7947_origin.rom 中：

- 解锁了 `msr` 寄存器、解禁了主板中隐藏的各项设置。

- 修改开机Logo为Apple。

- 添加了CsmVideoDxe模块。

可以在UEFI界面下默认以4k输出了。而且没有性能问题：）

- 添加了NVMe支持。

### 在 x7947_ozm_all_cpu.fd 中：

- 包含 x7947_origin.rom 的改动。

- 在DSDT中增加了macmini6,2的处理器变频向量。

- 内嵌的`OzmosisDefaults`中处理器类型`CpuType`为Xeon。

- 添加了所有Modules中的模块，除了`VoodooTSCSync`。

### 在 x7947_ozm_e5_2670.fd 中：

- 包含 x7947_ozm_all_cpu.fd 的改动。

- 添加了适用于8核心的`VoodooTSCSync`。

- 整合了e5-2670 v1的SSDT代码。

## 1.5 Ozmosis模块说明：

### 1.5.1 核心模块：

所有核心模块位于`Modules/core/`中。无论使用什么主板，这些都是必须的。

要么插入到ROM中，要么使用UEFI SHELL加载。

- `SmcEmulator.ffs`(也就是`FakeSmc`)：关键Kext。

- `Ozmosis.ffs`：Ozmosis引导器。

- `DisablerKext.ffs`：禁止某Kext加载。

- `InjectorKext.ffs`：加载某Kext。与上面的`DisablerKext`共同实现控制Kext加载。

- `HfsPlus.ffs`：苹果Hfs+文件系统驱动。

- `EnhancedFat.ffs`：Fat文件系统驱动。

- `PartitionDxe.ffs`：支持多种分区表。

### 1.5.2 可选模块：

所有可选模块位于`Modules/optional/`中。这些因主板而异，如果空间不足，可以不插入ROM中。

- `OzmosisHorizontalTheme.ffs`：Ozmosis 主题。

- `Btrfs.ffs`：一种 Linux 文件系统驱动。

- `KernextPatcher.ffs`：提供类似于Clover的`KextToPatch`功能。然而作为模块插入BIOS的时候我一直没试成功。

- `OzmosisDefaults.ffs`：Ozmosis 配置文件。如果不插入BIOS，则必须放置`EFI/Oz/Defaults.plist`。

- `RealtekRTL8111.ffs`：网卡驱动。

- `USBInjectAll.ffs`：USB2.0驱动。

- `VoodooTSCSync.ffs`：这是8核心的VoodooTSCSync.kext转化而来。

Kext 转 ffs 请使用`Tools/Dsdt2Bios`工具转换。转换时，请务必将所有待插入ROM的kext都转换，然后全部重新插入，否则会冲突。

## 1.6 对于NVIDIA显卡


### 1.6.1 显示器无输出

我在DSDT中将显卡的名称修改为`GFX1`以解决`MacPro 6,1`下无输出的问题。你不用任何操作。

### 1.6.2 图形加速

如果装好了系统却没有图形加速效果，安装Web Driver即可。

**装好WEB DRIVER以后切记不要安装系统更新！！！**

### 1.6.3 高清启动界面

我在ROM中添加了CsmVideoDxe模块，如果你刷新了BIOS，那么请在`boot`->`CSM`中，将`Lagecy Only`改为`UEFI Only`。

然后享受4k画质的开机画面即可。

## 1.7 对于AMD显卡

俺没有AMD显卡，所以你只能靠你自己了。

## 1.8 网卡: Rtl8100/8600

就是它驱动起来的网卡：`RealtekRTL8111.ffs`。

## 1.9 声卡: Reltek ALC662 V3

为了更好的音质，使用了AppleALC驱动。关键Kext为：

`Lilu.kext`、`AppleALC.kext`、`HDAEnabler.kext`。

如果不是ALC662 V3的声卡，可以使用`VoodooHDA`万能声卡驱动。其中：

VoodooHDA 2.8.9：只支持双声道。

VoodooHDA 2.9.0：支持5.1声道。

# 2 macOS兼容性:

- 10.12 macOS Sierra: 良好.

- 10.13.1 macOS High Sierra: 未测试.

# 3 致谢:

- [Apple](https://www.apple.com)：研发的 macOS 系统
- [Clover EFI bootloader](https://sourceforge.net/projects/cloverefiboot/)：强大的通用操作系统引导器
- @[**vit9696**](https://github.com/vit9696)：制作 Lilu & AppleALC
- [Piker.R.Alpha](https://pikeralpha.wordpress.com/)：对AICPM做出的研究、制作 ssdtPRGen.sh
- [Alext James](https://alextjam.es/)(@**TheRaceMaster**)：对ACPI表的解析问题的分析
- @[**PMHeart**](https://github.com/PMheart)：制作 CPUFriend，并热心的帮助了我
- @[**stinga11**](http://www.insanelymac.com/forum/user/408886-stinga11/)：X79系列CPU变频的研究
- [Rampage Dev](http://rampagedev.com)：提供的 SSDT
- @[**shilohh**](https://www.tonymacx86.com/members/shilohh.312762)：解决NVIDIA显卡无输出问题
- @**flipphos** & @**zouyanggary** & @**jameszhang18910780315**：BIOS方面的资讯
- @**zouyanggary** & **kaeserlin**：提供的AppleALC方面的资讯
- [远景论坛](http://bbs.pcbeta.com) & [Tonymacx86](https://www.tonymacx86.com) & [InsanelyMac](http://www.insanelymac.com)：提供交流的场所

## 资助列表：

| 昵称              | 金额   | 备注   | 时间         |
| --------------- | ---- | ---- | ---------- |
