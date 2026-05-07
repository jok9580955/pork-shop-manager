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
- `fastlane/metadata/zh-Hans` 中文商店文案已生成。
- 隐私政策和支持页面已生成到 `docs/`。

## 待完成

- Bundle ID 需要换成真实、可上架的反向域名格式。
- App Store Connect API key / Fastlane 尚未配置。
- 隐私政策和支持页面尚未发布为公网 URL。
- metadata 中的隐私/支持链接仍是占位链接。
- App Store 截图尚未生成。
- App 隐私问卷尚未填写。
- 审核联系信息、年龄分级、价格、版权、内容权利尚未完成。
- Release 归档上传需要在上述材料准备后再做。

## 下一步建议

先初始化或连接 GitHub 仓库，发布 `docs/` 页面，再把真实隐私/支持 URL 写回 metadata。
