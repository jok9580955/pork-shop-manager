#!/usr/bin/env python3
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

OUT = Path("fastlane/screenshots-ios/zh-Hans")
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

SCREENS = [
    ("01-dashboard", "每天经营，一屏看清", "销售额、出肉率、库存和毛利都在首页。", "dashboard"),
    ("02-cutting-calculator", "分割核算自动算", "录入重量和售价，自动计算损耗、出肉率和毛利。", "calculator"),
    ("03-inventory", "库存按部位管理", "按部位、批次和重量记录库存，少漏记。", "inventory"),
    ("04-finance", "财务流水更清楚", "收入、支出、欠款和预计毛利集中查看。", "finance"),
    ("05-local-data", "小店数据本地保存", "无需登录，核算单保存在设备本地。", "privacy"),
]


def font(size, bold=False):
    return ImageFont.truetype(FONT_BOLD if bold else FONT_REG, size)


def text(draw, xy, value, size, fill=None, bold=False, anchor=None):
    draw.text(xy, value, font=font(size, bold), fill=fill or COLORS["ink"], anchor=anchor)


def rect(draw, box, fill, outline=None, width=1, radius=24):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def wrap(draw, xy, value, width, size, fill=None, bold=False, line_gap=10):
    x, y = xy
    line = ""
    for ch in value:
        candidate = line + ch
        if draw.textlength(candidate, font=font(size, bold)) > width and line:
            text(draw, (x, y), line, size, fill, bold)
            y += size + line_gap
            line = ch
        else:
            line = candidate
    if line:
        text(draw, (x, y), line, size, fill, bold)
    return y + size


def icon(draw, cx, cy, label, color, scale=1):
    r = int(34 * scale)
    rect(draw, (cx - r, cy - r, cx + r, cy + r), color, radius=int(10 * scale))
    text(draw, (cx, cy - int(2 * scale)), label, int(30 * scale), (255, 255, 255), True, "mm")


def metric(draw, x, y, w, h, title, value, mark, color, scale):
    rect(draw, (x, y, x + w, y + h), COLORS["panel"], COLORS["border"], radius=int(18 * scale))
    icon(draw, x + int(50 * scale), y + int(48 * scale), mark, color, scale)
    text(draw, (x + int(24 * scale), y + int(100 * scale)), value, int(30 * scale), bold=True)
    text(draw, (x + int(24 * scale), y + int(135 * scale)), title, int(18 * scale), COLORS["muted"])


def base(size, title, subtitle):
    w, h = size
    scale = w / 1242
    im = Image.new("RGB", size, COLORS["bg"])
    d = ImageDraw.Draw(im)
    pad = int(58 * scale)
    rect(d, (pad, pad, w - pad, h - pad), COLORS["panel"], COLORS["border"], radius=int(34 * scale))
    text(d, (pad + int(50 * scale), pad + int(70 * scale)), "猪肉铺店铺管家", int(31 * scale), COLORS["red"], True)
    wrap(d, (pad + int(50 * scale), pad + int(138 * scale)), title, w - pad * 2 - int(100 * scale), int(58 * scale), bold=True, line_gap=int(14 * scale))
    wrap(d, (pad + int(50 * scale), pad + int(292 * scale)), subtitle, w - pad * 2 - int(100 * scale), int(27 * scale), COLORS["muted"])
    return im, d, scale, (pad, pad, w - pad, h - pad)


def draw_dashboard(d, box, scale):
    x0, y0, x1, y1 = box
    y = y0 + int(470 * scale)
    rect(d, (x0 + int(50 * scale), y, x1 - int(50 * scale), y + int(1040 * scale)), COLORS["bg"], COLORS["border"], radius=int(26 * scale))
    text(d, (x0 + int(92 * scale), y + int(70 * scale)), "今天经营", int(42 * scale), bold=True)
    rect(d, (x1 - int(305 * scale), y + int(55 * scale), x1 - int(95 * scale), y + int(108 * scale)), COLORS["soft_red"], radius=int(27 * scale))
    text(d, (x1 - int(200 * scale), y + int(80 * scale)), "营业中", int(23 * scale), COLORS["red"], True, "mm")
    card_w = int(450 * scale)
    card_h = int(170 * scale)
    gap = int(28 * scale)
    left = x0 + int(92 * scale)
    top = y + int(160 * scale)
    metric(d, left, top, card_w, card_h, "预计销售额", "¥3,286", "¥", COLORS["red"], scale)
    metric(d, left + card_w + gap, top, card_w, card_h, "最近出肉率", "78.4%", "%", COLORS["orange"], scale)
    metric(d, left, top + card_h + gap, card_w, card_h, "已核库存", "75.7kg", "箱", COLORS["blue"], scale)
    metric(d, left + card_w + gap, top + card_h + gap, card_w, card_h, "预计毛利", "¥860", "↗", COLORS["green"], scale)
    text(d, (left, top + int(440 * scale)), "近期记录", int(31 * scale), bold=True)
    list_y = top + int(510 * scale)
    for i, (title, note, amount, color) in enumerate([
        ("白条猪入库", "96.5kg，供应商：城东批发", "-¥1,930", COLORS["blue"]),
        ("五花肉销售", "客户：老张饭店，12.0kg", "+¥528", COLORS["green"]),
        ("分割损耗记录", "修割损耗 2.1kg", "2.1kg", COLORS["orange"]),
    ]):
        yy = list_y + i * int(145 * scale)
        icon(d, left + int(42 * scale), yy + int(42 * scale), "·", color, scale)
        text(d, (left + int(105 * scale), yy + int(16 * scale)), title, int(26 * scale), bold=True)
        text(d, (left + int(105 * scale), yy + int(54 * scale)), note, int(21 * scale), COLORS["muted"])
        text(d, (x1 - int(105 * scale), yy + int(43 * scale)), amount, int(25 * scale), color, True, "rm")


def draw_calculator(d, box, scale):
    x0, y0, x1, y1 = box
    left = x0 + int(92 * scale)
    top = y0 + int(470 * scale)
    card_w = int(450 * scale)
    card_h = int(170 * scale)
    gap = int(28 * scale)
    metric(d, left, top, card_w, card_h, "出肉率", "78.4%", "%", COLORS["red"], scale)
    metric(d, left + card_w + gap, top, card_w, card_h, "损耗重量", "20.8kg", "剪", COLORS["orange"], scale)
    metric(d, left, top + card_h + gap, card_w, card_h, "出肉成本", "¥25.5/kg", "¥", COLORS["blue"], scale)
    metric(d, left + card_w + gap, top + card_h + gap, card_w, card_h, "预计毛利", "¥860", "↗", COLORS["green"], scale)
    panel_y = top + int(420 * scale)
    rect(d, (left, panel_y, x1 - int(92 * scale), panel_y + int(520 * scale)), COLORS["panel"], COLORS["border"], radius=int(22 * scale))
    text(d, (left + int(40 * scale), panel_y + int(55 * scale)), "分割部位", int(32 * scale), bold=True)
    parts = [("五花肉", "18.6kg", "¥44/kg"), ("前腿肉", "21.4kg", "¥32/kg"), ("后腿肉", "24.2kg", "¥34/kg"), ("排骨", "8.9kg", "¥58/kg")]
    for i, part in enumerate(parts):
        yy = panel_y + int(125 * scale) + i * int(76 * scale)
        text(d, (left + int(45 * scale), yy), part[0], int(27 * scale), bold=True)
        text(d, (left + int(460 * scale), yy), part[1], int(25 * scale), COLORS["muted"])
        text(d, (x1 - int(135 * scale), yy), part[2], int(25 * scale), COLORS["green"], True, "rm")


def draw_inventory(d, box, scale):
    x0, y0, x1, y1 = box
    left = x0 + int(92 * scale)
    top = y0 + int(485 * scale)
    rect(d, (left, top, x1 - int(92 * scale), top + int(900 * scale)), COLORS["panel"], COLORS["border"], radius=int(22 * scale))
    items = [("五花肉", "18.6kg", "正常销售", COLORS["green"]), ("前腿肉", "21.4kg", "补充标价", COLORS["blue"]), ("后腿肉", "24.2kg", "重点推荐", COLORS["green"]), ("排骨", "8.9kg", "库存偏低", COLORS["orange"]), ("碎肉/边角", "2.6kg", "尽快处理", COLORS["orange"])]
    for i, (name, weight, action, color) in enumerate(items):
        yy = top + int(70 * scale) + i * int(145 * scale)
        icon(d, left + int(58 * scale), yy + int(20 * scale), "箱", color, scale)
        text(d, (left + int(130 * scale), yy - int(10 * scale)), name, int(31 * scale), bold=True)
        text(d, (left + int(130 * scale), yy + int(34 * scale)), f"当前库存 {weight} · 批次 2026-05-08", int(22 * scale), COLORS["muted"])
        rect(d, (x1 - int(310 * scale), yy - int(8 * scale), x1 - int(115 * scale), yy + int(44 * scale)), (246, 242, 236), radius=int(25 * scale))
        text(d, (x1 - int(212 * scale), yy + int(17 * scale)), action, int(21 * scale), color, True, "mm")


def draw_finance(d, box, scale):
    x0, y0, x1, y1 = box
    left = x0 + int(92 * scale)
    top = y0 + int(470 * scale)
    card_w = int(450 * scale)
    card_h = int(170 * scale)
    gap = int(28 * scale)
    metric(d, left, top, card_w, card_h, "今日收入", "¥3,286", "收", COLORS["green"], scale)
    metric(d, left + card_w + gap, top, card_w, card_h, "今日支出", "¥1,930", "支", COLORS["red"], scale)
    metric(d, left, top + card_h + gap, card_w, card_h, "待收欠款", "¥920", "欠", COLORS["purple"], scale)
    metric(d, left + card_w + gap, top + card_h + gap, card_w, card_h, "预计毛利", "¥860", "利", COLORS["blue"], scale)
    panel_y = top + int(430 * scale)
    rect(d, (left, panel_y, x1 - int(92 * scale), panel_y + int(410 * scale)), COLORS["panel"], COLORS["border"], radius=int(22 * scale))
    text(d, (left + int(42 * scale), panel_y + int(58 * scale)), "近期财务记录", int(32 * scale), bold=True)
    for i, (name, note, amount, color) in enumerate([("五花肉销售", "老张饭店，12.0kg", "+¥528", COLORS["green"]), ("白条猪入库", "城东批发，96.5kg", "-¥1,930", COLORS["red"]), ("排骨预订", "客户自提，明早 9 点", "+¥260", COLORS["green"])]):
        yy = panel_y + int(125 * scale) + i * int(78 * scale)
        text(d, (left + int(48 * scale), yy), name, int(25 * scale), bold=True)
        text(d, (left + int(260 * scale), yy), note, int(22 * scale), COLORS["muted"])
        text(d, (x1 - int(130 * scale), yy), amount, int(25 * scale), color, True, "rm")


def draw_privacy(d, box, scale):
    x0, y0, x1, y1 = box
    left = x0 + int(100 * scale)
    top = y0 + int(500 * scale)
    cards = [("本地保存", "经营核算单保存在本机，关闭 App 后也能继续查看。", COLORS["red"], "锁"), ("无需登录", "当前版本不需要注册账号，也不需要测试账号。", COLORS["blue"], "人"), ("快速回看", "首页自动汇总最近核算结果、出肉率和预计毛利。", COLORS["green"], "表")]
    for i, (title, note, color, mark) in enumerate(cards):
        yy = top + i * int(240 * scale)
        rect(d, (left, yy, x1 - int(100 * scale), yy + int(180 * scale)), COLORS["panel"], COLORS["border"], radius=int(22 * scale))
        icon(d, left + int(70 * scale), yy + int(72 * scale), mark, color, scale)
        text(d, (left + int(145 * scale), yy + int(45 * scale)), title, int(34 * scale), bold=True)
        wrap(d, (left + int(145 * scale), yy + int(92 * scale)), note, int(690 * scale), int(23 * scale), COLORS["muted"])


DRAWERS = {
    "dashboard": draw_dashboard,
    "calculator": draw_calculator,
    "inventory": draw_inventory,
    "finance": draw_finance,
    "privacy": draw_privacy,
}


def generate(size, prefix):
    for idx, (name, title, subtitle, kind) in enumerate(SCREENS, 1):
        im, d, scale, box = base(size, title, subtitle)
        DRAWERS[kind](d, box, scale)
        im.save(OUT / f"{prefix}_{idx:02d}-{name}.png")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for p in OUT.glob("*.png"):
        p.unlink()
    generate((1242, 2688), "iPhone_65")
    generate((2064, 2752), "iPad_129")


if __name__ == "__main__":
    main()
