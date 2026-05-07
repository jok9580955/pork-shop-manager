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

## 待完成

- Bundle ID 需要换成真实、可上架的反向域名格式。
- App Store Connect API key / Fastlane 尚未配置。
- App Store Connect API key / Fastlane 上传 lanes 尚未配置。
- App 内 UI 还没有 `.xcstrings` 本地化。
- App Store 截图尚未生成。
- App 隐私问卷尚未填写。
- 审核联系信息、年龄分级、价格、版权、内容权利尚未完成。
- Release 归档上传需要在上述材料准备后再做。

## 下一步建议

配置 Fastlane 和 App Store Connect API key，然后补 App 内本地化与截图模式。
