#!/usr/bin/env python3
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

W, H = 1440, 900
OUT = Path("fastlane/screenshots/zh-Hans")
FONT_REG = "/System/Library/Fonts/Hiragino Sans GB.ttc"
FONT_BOLD = "/System/Library/Fonts/STHeiti Medium.ttc"

COLORS = {
    "bg": (247, 244, 239),
    "panel": (255, 255, 255),
    "ink": (40, 36, 34),
    "muted": (104, 99, 95),
    "border": (226, 218, 211),
    "red": (171, 31, 34),
    "soft_red": (252, 231, 226),
    "green": (43, 141, 79),
    "blue": (42, 105, 180),
    "orange": (210, 125, 36),
    "purple": (119, 78, 160),
}


def font(size, bold=False):
    return ImageFont.truetype(FONT_BOLD if bold else FONT_REG, size)


def text(draw, xy, value, size=28, fill=None, bold=False, anchor=None):
    draw.text(xy, value, font=font(size, bold), fill=fill or COLORS["ink"], anchor=anchor)


def rect(draw, box, fill, outline=None, width=1, radius=10):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def icon(draw, cx, cy, label, color, size=46):
    rect(draw, (cx - 34, cy - 34, cx + 34, cy + 34), color, radius=10)
    text(draw, (cx, cy - 3), label, size=size, fill=(255, 255, 255), bold=True, anchor="mm")


def base(title, subtitle):
    im = Image.new("RGB", (W, H), COLORS["bg"])
    d = ImageDraw.Draw(im)
    rect(d, (58, 54, W - 58, H - 54), COLORS["panel"], COLORS["border"], radius=16)
    text(d, (108, 112), "猪肉铺店铺管家", 28, COLORS["red"], True)
    text(d, (108, 176), title, 58, COLORS["ink"], True)
    text(d, (110, 246), subtitle, 28, COLORS["muted"])
    return im, d


def metric(draw, x, y, title, value, tag, color):
    rect(draw, (x, y, x + 250, y + 140), (255, 255, 255), COLORS["border"], radius=10)
    icon(draw, x + 48, y + 48, tag, color, size=32)
    text(draw, (x + 28, y + 96), value, 30, COLORS["ink"], True)
    text(draw, (x + 28, y + 126), title, 18, COLORS["muted"])


def row(draw, x, y, title, note, amount, color):
    icon(draw, x + 42, y + 42, "·", color, size=30)
    text(draw, (x + 92, y + 22), title, 25, bold=True)
    text(draw, (x + 92, y + 58), note, 20, COLORS["muted"])
    text(draw, (x + 720, y + 42), amount, 24, color, True, anchor="rm")


def compact_row(draw, x, y, title, note, amount, color):
    icon(draw, x + 42, y + 42, "·", color, size=30)
    text(draw, (x + 92, y + 22), title, 25, bold=True)
    text(draw, (x + 92, y + 58), note, 20, COLORS["muted"])
    text(draw, (x + 360, y + 42), amount, 24, color, True, anchor="rm")


def screenshot_dashboard():
    im, d = base("每天经营，一屏看清", "把分割核算、库存、客户和财务记录放在同一个经营看板里。")
    rect(d, (110, 320, 1330, 805), COLORS["bg"], COLORS["border"], radius=14)
    text(d, (150, 372), "今天经营", 42, bold=True)
    text(d, (152, 420), "分割、库存、客户、财务一眼看清", 22, COLORS["muted"])
    rect(d, (1040, 360, 1220, 404), COLORS["soft_red"], radius=22)
    text(d, (1130, 381), "营业中", 22, COLORS["red"], True, anchor="mm")
    metric(d, 150, 475, "预计销售额", "¥3,286.00", "¥", COLORS["red"])
    metric(d, 425, 475, "最近出肉率", "78.4%", "%", COLORS["orange"])
    metric(d, 700, 475, "已核库存", "75.70kg", "箱", COLORS["blue"])
    metric(d, 975, 475, "预计毛利", "¥860.20", "↗", COLORS["green"])
    text(d, (150, 680), "近期记录", 28, bold=True)
    compact_row(d, 150, 718, "白条猪入库", "96.5kg，供应商：城东批发", "-¥1,930", COLORS["blue"])
    compact_row(d, 660, 718, "五花肉销售", "客户：老张饭店，12.0kg", "+¥528", COLORS["green"])
    save(im, "01-dashboard.png")


def screenshot_calculator():
    im, d = base("分割核算自动算", "输入进货重量、成本和各部位售价，自动计算出肉率、损耗和预计毛利。")
    metric(d, 110, 335, "出肉率", "78.4%", "%", COLORS["red"])
    metric(d, 385, 335, "损耗重量", "20.80kg", "剪", COLORS["orange"])
    metric(d, 660, 335, "出肉成本", "¥25.50/kg", "¥", COLORS["blue"])
    metric(d, 935, 335, "预计毛利", "¥860.20", "↗", COLORS["green"])
    rect(d, (110, 520, 655, 790), COLORS["panel"], COLORS["border"], radius=12)
    text(d, (150, 570), "进货信息", 30, bold=True)
    for i, (k, v) in enumerate([("供应商", "城东批发"), ("进货重量 kg", "96.5"), ("总成本 ¥", "1930")]):
        y = 620 + i * 52
        text(d, (150, y), k, 21, COLORS["muted"])
        text(d, (395, y), v, 23, bold=True)
    rect(d, (705, 520, 1330, 790), COLORS["panel"], COLORS["border"], radius=12)
    text(d, (745, 570), "分割部位", 30, bold=True)
    parts = [("五花肉", "18.6kg", "¥44/kg"), ("前腿肉", "21.4kg", "¥32/kg"), ("后腿肉", "24.2kg", "¥34/kg"), ("排骨", "8.9kg", "¥58/kg")]
    for i, part in enumerate(parts):
        y = 625 + i * 44
        text(d, (745, y), part[0], 22, bold=True)
        text(d, (1010, y), part[1], 22, COLORS["muted"])
        text(d, (1215, y), part[2], 22, COLORS["green"], True)
    save(im, "02-cutting-calculator.png")


def screenshot_inventory():
    im, d = base("库存按部位和批次管理", "记录每批货的部位库存、重量和预警，减少漏记和损耗。")
    rect(d, (110, 340, 1330, 780), COLORS["panel"], COLORS["border"], radius=14)
    headers = ["部位", "当前库存", "批次", "建议动作"]
    xs = [160, 500, 805, 1080]
    for x, h in zip(xs, headers):
        text(d, (x, 390), h, 22, COLORS["muted"], True)
    items = [
        ("五花肉", "18.6kg", "2026-05-08", "正常销售"),
        ("前腿肉", "21.4kg", "2026-05-08", "补充标价"),
        ("后腿肉", "24.2kg", "2026-05-08", "重点推荐"),
        ("排骨", "8.9kg", "2026-05-08", "库存偏低"),
        ("碎肉/边角", "2.6kg", "2026-05-08", "尽快处理"),
    ]
    for i, item in enumerate(items):
        y = 455 + i * 62
        d.line((140, y - 22, 1300, y - 22), fill=COLORS["border"], width=1)
        text(d, (160, y), item[0], 26, bold=True)
        text(d, (500, y), item[1], 25, COLORS["ink"], True)
        text(d, (805, y), item[2], 22, COLORS["muted"])
        color = COLORS["orange"] if i >= 3 else COLORS["green"]
        rect(d, (1080, y - 22, 1225, y + 18), (246, 242, 236), radius=20)
        text(d, (1152, y - 2), item[3], 19, color, True, anchor="mm")
    save(im, "03-inventory.png")


def screenshot_finance():
    im, d = base("财务流水更清楚", "收入、支出、欠款和预计毛利放在一起，月底回看不再靠脑子记。")
    metric(d, 130, 350, "今日收入", "¥3,286", "收", COLORS["green"])
    metric(d, 405, 350, "今日支出", "¥1,930", "支", COLORS["red"])
    metric(d, 680, 350, "待收欠款", "¥920", "欠", COLORS["purple"])
    metric(d, 955, 350, "预计毛利", "¥860", "利", COLORS["blue"])
    rect(d, (130, 545, 1310, 780), COLORS["panel"], COLORS["border"], radius=14)
    text(d, (170, 595), "近期财务记录", 30, bold=True)
    rows = [
        ("五花肉销售", "老张饭店，12.0kg", "+¥528", COLORS["green"]),
        ("白条猪入库", "城东批发，96.5kg", "-¥1,930", COLORS["red"]),
        ("排骨预订", "客户自提，明早 9 点", "+¥260", COLORS["green"]),
    ]
    for i, r in enumerate(rows):
        row(d, 170, 625 + i * 54, r[0], r[1], r[2], r[3])
    save(im, "04-finance.png")


def screenshot_privacy():
    im, d = base("小店数据，本地保存", "核算单保存在设备本地，无需登录，适合店主日常快速记录。")
    rect(d, (130, 340, 1310, 780), COLORS["panel"], COLORS["border"], radius=14)
    cards = [
        ("本地保存", "经营核算单保存在本机，关闭 App 后也能继续查看。", COLORS["red"], "锁"),
        ("无需登录", "当前版本不需要注册账号，也不需要测试账号。", COLORS["blue"], "人"),
        ("快速回看", "首页自动汇总最近核算结果、出肉率和预计毛利。", COLORS["green"], "表"),
    ]
    for i, (title, note, color, mark) in enumerate(cards):
        x = 185 + i * 380
        icon(d, x + 50, 430, mark, color, size=30)
        text(d, (x, 515), title, 34, bold=True)
        text_wrapped(d, (x, 570), note, 270, 24, COLORS["muted"])
    rect(d, (360, 690, 1080, 740), COLORS["soft_red"], radius=25)
    text(d, (720, 714), "让小店老板每天快速记账、快速核算、快速看懂经营结果", 24, COLORS["red"], True, anchor="mm")
    save(im, "05-local-data.png")


def text_wrapped(draw, xy, value, width, size, fill):
    x, y = xy
    line = ""
    for ch in value:
        candidate = line + ch
        if draw.textlength(candidate, font=font(size)) > width and line:
            text(draw, (x, y), line, size, fill)
            y += size + 10
            line = ch
        else:
            line = candidate
    if line:
        text(draw, (x, y), line, size, fill)


def save(im, name):
    OUT.mkdir(parents=True, exist_ok=True)
    im.save(OUT / name)


def main():
    screenshot_dashboard()
    screenshot_calculator()
    screenshot_inventory()
    screenshot_finance()
    screenshot_privacy()


if __name__ == "__main__":
    main()
