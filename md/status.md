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

## 待完成

- App 内 UI 还没有 `.xcstrings` 本地化。
- App Store 截图尚未生成。
- App 隐私问卷尚未填写。
- App Store Connect 还需要上传并选择一个有效构建版本。
- 价格/销售范围需要在 App Store Connect 确认。
- 当前 App Store Connect 红项来自 macOS App 版本页；如后续改为 iOS 首发，需要在 iOS 版本页再执行对应上传流程。

## 下一步建议

先上传一个 macOS 有效构建版本，然后在 App Store Connect 填写 App 隐私问卷并选择构建版本。
