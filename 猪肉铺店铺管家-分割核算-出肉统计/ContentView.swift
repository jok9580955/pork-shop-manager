//
//  ContentView.swift
//  猪肉铺店铺管家-分割核算-出肉统计
//
//  Created by ll on 2026/5/6.
//

import Foundation
import SwiftUI

struct ContentView: View {
    private let modules = StoreModule.sampleData
    private let sheetStore = CuttingSheetStore()
    @State private var selectedTab = AppTab.home
    @State private var cuttingSheets = [CuttingSheet]()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header
                        metricsGrid
                        quickActions
                        recentRecords
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                }
                .background(AppColor.pageBackground)
                .navigationTitle("店铺管家")
                .toolbarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("首页", systemImage: "house.fill")
            }
            .tag(AppTab.home)

            CuttingCalculatorScreen { sheet in
                cuttingSheets.insert(sheet, at: 0)
                sheetStore.save(cuttingSheets)
                selectedTab = .home
            }
            .tabItem {
                Label("核算", systemImage: "scalemass.fill")
            }
            .tag(AppTab.calculator)

            PlaceholderScreen(
                title: "库存管理",
                subtitle: "按部位、批次和保质期管理库存，减少漏记和损耗。",
                icon: "shippingbox.fill"
            )
            .tabItem {
                Label("库存", systemImage: "shippingbox.fill")
            }
            .tag(AppTab.inventory)

            PlaceholderScreen(
                title: "财务记录",
                subtitle: "跟踪收入、支出、欠款和日结，形成清楚的经营流水。",
                icon: "yensign.circle.fill"
            )
            .tabItem {
                Label("财务", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(AppTab.finance)
        }
        .tint(AppColor.primary)
        .task {
            guard cuttingSheets.isEmpty else { return }
            cuttingSheets = sheetStore.load()
        }
    }

    private var metrics: [DashboardMetric] {
        let latestYield = cuttingSheets.first?.yieldRate ?? 0
        let totalOutput = cuttingSheets.reduce(0) { $0 + $1.outputWeight }
        let totalRevenue = cuttingSheets.reduce(0) { $0 + $1.estimatedRevenue }
        let totalProfit = cuttingSheets.reduce(0) { $0 + $1.grossProfit }

        return [
            DashboardMetric(title: "预计销售额", value: moneyText(totalRevenue), trend: "+核算", icon: "yensign.circle.fill", color: AppColor.primary, trendColor: .green),
            DashboardMetric(title: "最近出肉率", value: percentText(latestYield), trend: "最新", icon: "percent", color: .orange, trendColor: .secondary),
            DashboardMetric(title: "已核库存", value: weightText(totalOutput), trend: "\(cuttingSheets.count)单", icon: "shippingbox.fill", color: .blue, trendColor: .orange),
            DashboardMetric(title: "预计毛利", value: moneyText(totalProfit), trend: "试算", icon: "chart.line.uptrend.xyaxis", color: .green, trendColor: AppColor.primary)
        ]
    }

    private var records: [BusinessRecord] {
        cuttingSheets.prefix(6).map { sheet in
            BusinessRecord(
                title: "保存核算单",
                note: "\(sheet.supplier)，出肉 \(weightText(sheet.outputWeight))，出肉率 \(percentText(sheet.yieldRate))",
                amount: moneyText(sheet.grossProfit),
                icon: "scalemass.fill",
                color: AppColor.primary,
                amountColor: sheet.grossProfit >= 0 ? .green : AppColor.primary
            )
        } + BusinessRecord.sampleData
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("今天经营")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    Text("分割、库存、客户、财务一眼看清")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                    .accessibilityHidden(true)
            }

            HStack(spacing: 10) {
                StatusPill(title: "营业中", icon: "storefront.fill")
                StatusPill(title: "数据已保存", icon: "lock.fill")
            }
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        }
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
            ForEach(metrics) { metric in
                MetricCard(metric: metric)
            }
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "常用功能", actionTitle: "管理全部")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(modules) { module in
                    ModuleTile(module: module)
                }
            }
        }
    }

    private var recentRecords: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "近期记录", actionTitle: "查看流水")

            VStack(spacing: 0) {
                ForEach(records) { record in
                    RecordRow(record: record)

                    if record.id != records.last?.id {
                        Divider()
                            .padding(.leading, 52)
                    }
                }
            }
            .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppColor.border, lineWidth: 1)
            }
        }
    }
}

private enum AppTab {
    case home
    case calculator
    case inventory
    case finance
}

private struct StatusPill: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppColor.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(AppColor.primarySoft, in: Capsule())
    }
}

private struct SectionTitle: View {
    let title: String
    let actionTitle: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Button(actionTitle) {}
                .font(.subheadline.weight(.semibold))
                .buttonStyle(.plain)
                .foregroundStyle(AppColor.primary)
        }
    }
}

private struct MetricCard: View {
    let metric: DashboardMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: metric.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(metric.color)
                    .frame(width: 32, height: 32)
                    .background(metric.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                Spacer()

                Text(metric.trend)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(metric.trendColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(metric.value)
                    .font(.title3.weight(.bold))
                    .monospacedDigit()
                Text(metric.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        }
    }
}

private struct ModuleTile: View {
    let module: StoreModule

    var body: some View {
        Button {
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: module.icon)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(module.color, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(module.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
            .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppColor.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct RecordRow: View {
    let record: BusinessRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: record.icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(record.color)
                .frame(width: 38, height: 38)
                .background(record.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(record.title)
                    .font(.subheadline.weight(.semibold))
                Text(record.note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(record.amount)
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(record.amountColor)
        }
        .padding(14)
    }
}

private struct PlaceholderScreen: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                    .frame(width: 76, height: 76)
                    .background(AppColor.primarySoft, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                Text(title)
                    .font(.title2.weight(.bold))

                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button {
                } label: {
                    Label("新增记录", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 8)
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.pageBackground)
            .navigationTitle(title)
        }
    }
}

private struct CuttingCalculatorScreen: View {
    let onSave: (CuttingSheet) -> Void
    @State private var supplier = "城东批发"
    @State private var inputWeight = "96.5"
    @State private var purchaseCost = "1930"
    @State private var parts = CuttingPart.sampleData
    @State private var showingSavedMessage = false

    private var inputWeightValue: Double {
        decimalValue(inputWeight)
    }

    private var purchaseCostValue: Double {
        decimalValue(purchaseCost)
    }

    private var outputWeight: Double {
        parts.reduce(0) { $0 + decimalValue($1.weight) }
    }

    private var estimatedRevenue: Double {
        parts.reduce(0) { total, part in
            total + decimalValue(part.weight) * decimalValue(part.salePrice)
        }
    }

    private var lossWeight: Double {
        max(inputWeightValue - outputWeight, 0)
    }

    private var yieldRate: Double {
        guard inputWeightValue > 0 else { return 0 }
        return outputWeight / inputWeightValue
    }

    private var inputUnitCost: Double {
        guard inputWeightValue > 0 else { return 0 }
        return purchaseCostValue / inputWeightValue
    }

    private var outputUnitCost: Double {
        guard outputWeight > 0 else { return 0 }
        return purchaseCostValue / outputWeight
    }

    private var grossProfit: Double {
        estimatedRevenue - purchaseCostValue
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    summaryCards
                    purchaseSection
                    partsSection
                    resultSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
            .background(AppColor.pageBackground)
            .navigationTitle("分割核算")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    parts.append(CuttingPart(name: "新部位", weight: "", salePrice: ""))
                } label: {
                    Label("新增部位", systemImage: "plus")
                }
            }
            .alert("核算单已保存", isPresented: $showingSavedMessage) {
                Button("知道了", role: .cancel) {}
            } message: {
                Text("已同步到首页经营概览和近期记录。")
            }
        }
    }

    private var summaryCards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
            CalculationSummaryCard(title: "出肉率", value: percentText(yieldRate), icon: "percent", color: AppColor.primary)
            CalculationSummaryCard(title: "损耗重量", value: weightText(lossWeight), icon: "scissors", color: .orange)
            CalculationSummaryCard(title: "出肉成本", value: moneyText(outputUnitCost) + "/kg", icon: "yensign.circle.fill", color: .blue)
            CalculationSummaryCard(title: "预计毛利", value: moneyText(grossProfit), icon: "chart.line.uptrend.xyaxis", color: grossProfit >= 0 ? .green : AppColor.primary)
        }
    }

    private var purchaseSection: some View {
        FormSection(title: "进货信息") {
            VStack(spacing: 12) {
                LabeledTextField(title: "供应商", text: $supplier, placeholder: "例如：城东批发")
                LabeledTextField(title: "进货重量 kg", text: $inputWeight, placeholder: "0.00", isNumber: true)
                LabeledTextField(title: "总成本 ¥", text: $purchaseCost, placeholder: "0.00", isNumber: true)

                ResultLine(title: "进货单价", value: moneyText(inputUnitCost) + "/kg")
            }
        }
    }

    private var partsSection: some View {
        FormSection(title: "分割部位") {
            VStack(spacing: 12) {
                ForEach($parts) { $part in
                    CuttingPartRow(part: $part)
                }

                Button {
                    parts.append(CuttingPart(name: "新部位", weight: "", salePrice: ""))
                } label: {
                    Label("添加部位", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
    }

    private var resultSection: some View {
        FormSection(title: "核算结果") {
            VStack(spacing: 10) {
                ResultLine(title: "总出肉重量", value: weightText(outputWeight))
                ResultLine(title: "损耗重量", value: weightText(lossWeight))
                ResultLine(title: "出肉率", value: percentText(yieldRate))
                ResultLine(title: "出肉后成本", value: moneyText(outputUnitCost) + "/kg")
                ResultLine(title: "预计销售额", value: moneyText(estimatedRevenue))
                ResultLine(title: "预计毛利", value: moneyText(grossProfit), valueColor: grossProfit >= 0 ? .green : AppColor.primary)

                Button {
                    saveSheet()
                } label: {
                    Label("保存核算单", systemImage: "tray.and.arrow.down.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 6)
            }
        }
    }

    private func saveSheet() {
        let savedSheet = CuttingSheet(
            supplier: supplier.isEmpty ? "未填写供应商" : supplier,
            inputWeight: inputWeightValue,
            purchaseCost: purchaseCostValue,
            parts: parts
        )
        onSave(savedSheet)
        showingSavedMessage = true
    }
}

private struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content
                .padding(14)
                .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(AppColor.border, lineWidth: 1)
                }
        }
    }
}

private struct CalculationSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(value)
                .font(.title3.weight(.bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        }
    }
}

private struct LabeledTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isNumber = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .numericKeyboard(isNumber)
        }
    }
}

private struct CuttingPartRow: View {
    @Binding var part: CuttingPart

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("部位名称", text: $part.name)
                .font(.subheadline.weight(.semibold))
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 10) {
                LabeledTextField(title: "重量 kg", text: $part.weight, placeholder: "0.00", isNumber: true)
                LabeledTextField(title: "售价 ¥/kg", text: $part.salePrice, placeholder: "0.00", isNumber: true)
            }

            ResultLine(
                title: "预计销售",
                value: moneyText(decimalValue(part.weight) * decimalValue(part.salePrice)),
                valueColor: .green
            )
        }
        .padding(12)
        .background(AppColor.pageBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct ResultLine: View {
    let title: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .monospacedDigit()
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

private struct DashboardMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let trend: String
    let icon: String
    let color: Color
    let trendColor: Color

    static let sampleData = [
        DashboardMetric(title: "今日销售额", value: "¥3,286", trend: "+12%", icon: "yensign.circle.fill", color: AppColor.primary, trendColor: .green),
        DashboardMetric(title: "出肉率", value: "78.4%", trend: "稳定", icon: "percent", color: .orange, trendColor: .secondary),
        DashboardMetric(title: "库存重量", value: "146.8kg", trend: "-18kg", icon: "shippingbox.fill", color: .blue, trendColor: .orange),
        DashboardMetric(title: "待收欠款", value: "¥920", trend: "2笔", icon: "person.text.rectangle.fill", color: .purple, trendColor: AppColor.primary)
    ]
}

private struct StoreModule: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    static let sampleData = [
        StoreModule(title: "分割核算", subtitle: "进货、分割、损耗、出肉率", icon: "scalemass.fill", color: AppColor.primary),
        StoreModule(title: "库存管理", subtitle: "部位库存、批次、预警", icon: "shippingbox.fill", color: .blue),
        StoreModule(title: "客户管理", subtitle: "客户档案、欠款、订货", icon: "person.2.fill", color: .purple),
        StoreModule(title: "财务记录", subtitle: "收入、支出、日结利润", icon: "chart.line.uptrend.xyaxis", color: .green)
    ]
}

private struct BusinessRecord: Identifiable {
    let id = UUID()
    let title: String
    let note: String
    let amount: String
    let icon: String
    let color: Color
    let amountColor: Color

    static let sampleData = [
        BusinessRecord(title: "白条猪入库", note: "96.5kg，供应商：城东批发", amount: "-¥1,930", icon: "tray.and.arrow.down.fill", color: .blue, amountColor: .primary),
        BusinessRecord(title: "五花肉销售", note: "客户：老张饭店，12.0kg", amount: "+¥528", icon: "cart.fill", color: .green, amountColor: .green),
        BusinessRecord(title: "分割损耗记录", note: "修割损耗 2.1kg", amount: "2.1kg", icon: "scissors", color: .orange, amountColor: .orange)
    ]
}

private struct CuttingPart: Identifiable, Codable {
    var id = UUID()
    var name: String
    var weight: String
    var salePrice: String

    static let sampleData = [
        CuttingPart(name: "五花肉", weight: "18.6", salePrice: "44"),
        CuttingPart(name: "前腿肉", weight: "21.4", salePrice: "32"),
        CuttingPart(name: "后腿肉", weight: "24.2", salePrice: "34"),
        CuttingPart(name: "排骨", weight: "8.9", salePrice: "58"),
        CuttingPart(name: "碎肉/边角", weight: "2.6", salePrice: "20")
    ]
}

private struct CuttingSheet: Identifiable, Codable {
    var id = UUID()
    var createdAt = Date()
    var supplier: String
    var inputWeight: Double
    var purchaseCost: Double
    var parts: [CuttingPart]

    var outputWeight: Double {
        parts.reduce(0) { $0 + decimalValue($1.weight) }
    }

    var estimatedRevenue: Double {
        parts.reduce(0) { total, part in
            total + decimalValue(part.weight) * decimalValue(part.salePrice)
        }
    }

    var yieldRate: Double {
        guard inputWeight > 0 else { return 0 }
        return outputWeight / inputWeight
    }

    var grossProfit: Double {
        estimatedRevenue - purchaseCost
    }

    static let sampleData = [
        CuttingSheet(
            supplier: "城东批发",
            inputWeight: 96.5,
            purchaseCost: 1930,
            parts: CuttingPart.sampleData
        )
    ]
}

private struct CuttingSheetStore {
    private let fileName = "cutting-sheets.json"

    func load() -> [CuttingSheet] {
        guard let data = try? Data(contentsOf: fileURL) else {
            return CuttingSheet.sampleData
        }

        do {
            let sheets = try JSONDecoder().decode([CuttingSheet].self, from: data)
            return sheets.isEmpty ? CuttingSheet.sampleData : sheets
        } catch {
            return CuttingSheet.sampleData
        }
    }

    func save(_ sheets: [CuttingSheet]) {
        do {
            let data = try JSONEncoder().encode(sheets)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
        }
    }

    private var fileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return (directory ?? URL(fileURLWithPath: NSTemporaryDirectory())).appendingPathComponent(fileName)
    }
}

private enum AppColor {
    static let primary = Color(red: 0.67, green: 0.12, blue: 0.13)
    static let primarySoft = Color(red: 0.98, green: 0.88, blue: 0.86)
    static let pageBackground = Color(red: 0.97, green: 0.96, blue: 0.94)
    static let border = Color.black.opacity(0.08)
}

private func decimalValue(_ text: String) -> Double {
    Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0
}

private func moneyText(_ value: Double) -> String {
    "¥" + String(format: "%.2f", value)
}

private func weightText(_ value: Double) -> String {
    String(format: "%.2fkg", value)
}

private func percentText(_ value: Double) -> String {
    String(format: "%.1f%%", value * 100)
}

private extension View {
    @ViewBuilder
    func numericKeyboard(_ enabled: Bool) -> some View {
        if enabled {
            #if os(iOS)
            keyboardType(.decimalPad)
            #else
            self
            #endif
        } else {
            self
        }
    }
}

#Preview {
    ContentView()
}
