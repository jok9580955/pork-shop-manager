# 上架准备状态

## 已完成

- App 图标已接入 `Assets.xcassets/AppIcon.appiconset`。
- iOS Simulator 构建通过。
- macOS 构建通过。
- `LSApplicationCategoryType` 已写入构建设置，值为 `public.app-category.business`。
- 首页经营看板已完成第一版。
- 分割核算表单已完成第一版。
- 核算单支持保存并回写首页。
- 核算单支持本地 JSON 持久化。
- `fastlane/metadata` 已生成 39 个语言/地区的商店文案。
- 39 个语言/地区的隐私政策和支持页面已生成到 `docs/` 并通过 GitHub Pages 发布。
- GitHub 仓库已创建并推送：`https://github.com/jok9580955/pork-shop-manager`。
- GitHub Pages 已启用：`https://jok9580955.github.io/pork-shop-manager/`。
- Fastlane 已配置 `ios` 和 `mac` 上架辅助 lane。
- macOS App Store 版本页的 39 语言元数据已上传成功。
- macOS App Store 版本页的审核联系信息已上传成功。
- macOS App Store 版本页的年龄分级问题已填写并上传成功。
- macOS App Store 版本页的主分类按 Business 方向配置。
- macOS Release 归档成功，版本为 `1.0 (2)`。
- macOS 构建版本 `1.0 (2)` 已上传到 App Store Connect，Apple 正在处理或等待处理完成。
- 已添加 App Store Connect 上传导出配置，可复用 `fastlane mac uploadbuild` 归档并上传 macOS 构建。
- 已生成并上传 5 张简体中文 Mac App Store 截图，尺寸为 `1440x900`。
- 已添加 `fastlane mac uppic`，可复用上传 macOS 截图。
- iOS Release 归档成功，版本为 `1.0 (2)`。
- iOS 构建版本 `1.0 (2)` 已上传到 App Store Connect，Apple 正在处理或等待处理完成。
- 已生成 5 张 iPhone 和 5 张 iPad 简体中文截图，分别为 `1242x2688` 和 `2064x2752`。
- 已添加 `fastlane ios uploadbuild` 和 `fastlane ios uppic`，可复用上传 iOS 构建和截图。

## 待完成

- App 内 UI 还没有 `.xcstrings` 本地化。
- App 隐私问卷尚未填写。
- App Store Connect 中构建处理完成后，需要在版本页选择构建版本 `1.0 (2)`。
- 价格/销售范围需要在 App Store Connect 确认。
- App Store Connect 需要通过“添加平台”创建 iOS 版本页；当前 Fastlane 无法上传 iOS 截图/文案，因为线上还没有可编辑的 iOS 版本。

## 下一步建议

在 App Store Connect 左侧点“添加平台”，选择 iOS 并创建 `1.0` 版本页；随后运行 `fastlane ios reviewprep` 和 `fastlane ios uppic` 上传 iOS 审核资料与截图。macOS 侧继续选择构建 `1.0 (2)`、填写 App 隐私问卷并确认价格/销售范围。
