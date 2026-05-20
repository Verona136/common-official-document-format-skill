# 常用公文格式技能

这是一个 Codex/AI agent 可读取的技能，用于在看到“公文、通知、函、报告、请示、批复、通报、纪要、方案、意见、决定、公告、专项检查、管理委员会、各单位、附件”等正式公文语境时，默认按常用中文公文格式输出 `.docx` Word 文档。

## 格式要点

- A4 纵向；页边距：上 3.3 cm，下 3.4 cm，左右 2.7 cm
- 标题：方正小标宋简体，居中
- 一级标题：黑体三号，不缩进
- 二级标题：楷体_GB2312 三号
- 正文：仿宋_GB2312，首行缩进 2 字符
- 固定行距 28 磅，段前段后 0 磅，字间距标准
- 页码：四号仿宋_GB2312，格式 `-1-`，右下角，奇偶页不同
- 清理多余空行、段首空格、段尾空格、重复空格和残留自动编号

## 安装脚本

```bash
bash install.sh --target codex
bash install.sh --target claude
bash install.sh --target openclaw
```

如需覆盖已安装版本：

```bash
bash install.sh --target codex --force
```

## 手动安装

也可以复制整个 `common-official-document-format-skill` 文件夹到你的 Codex skills 目录，例如：

```bash
cp -R common-official-document-format-skill ~/.codex/skills/common-official-document-format
```

重启 Codex 后即可使用。
