# 审核红项处理

## 本次准备

- 已添加 `fastlane/Fastfile`。
- 已添加 `fastlane/Appfile`。
- 已添加 `fastlane/age_rating_config.json`。
- 已添加本地忽略文件 `fastlane/.env`，用于 App Store Connect API key 路径和审核联系信息。
- 已添加 iOS 和 macOS 两套 Fastlane lane；当前 App Store Connect 红项来自 macOS App 版本页。
- 已执行 `fastlane mac reviewprep` 并成功上传 App Store Connect 审核前资料。
- 已归档并上传 macOS 构建 `1.0 (2)` 到 App Store Connect。
- 已生成并上传 5 张简体中文 Mac App Store 截图。
- 已归档并上传 iOS 构建 `1.0 (2)` 到 App Store Connect。
- 已生成 iPhone/iPad 简体中文截图；等待 iOS 版本页创建后上传。

## 已自动处理

- 简体中文描述、关键词、技术支持网址。
- 39 个语言/地区的商店文案。
- 主分类。
- 年龄分级配置。
- 审核联系信息。
- 内容版权声明。
- macOS 构建上传。
- 简体中文 Mac App Store 截图上传。
- iOS 构建上传。
- iOS 截图本地生成。

## 仍需人工或前置条件

- 等待 Apple 完成构建处理后，在 App Store Connect 版本页选择构建 `1.0 (2)`。
- App 隐私问卷需要具有管理权限的用户在 App Store Connect 中确认并发布。当前 App 的建议选择是：不收集数据。
- 价格和销售范围需要在 App Store Connect 中确认。
- 需要在 App Store Connect 点“添加平台”创建 iOS 版本页，然后才能上传 iOS 文案、截图并选择 iOS 构建。
