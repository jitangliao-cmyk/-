# NOVA ONE · 发布会概念短片

15 秒、1280×720、30fps。虚构品牌、简化三维手机和芯片，所有参数仅作演示。包含原创合成电子配乐。

## 完整工作流程

1. 拆解参考片：约 89 秒，包含产品特写、照片墙、功能字卡和芯片展示。参考片仅用于风格分析，未复制其画面或音轨。
2. [Figma 分镜与视觉稿](https://www.figma.com/design/DXHmWy7rZ1DiLJHEaY9xce)：四个可编辑镜头。
3. 从官方 GitHub 获取 [Three.js r180](https://github.com/mrdoob/three.js/tree/r180)，MIT 许可证及原署名保存在 vendor/LICENSE-three.txt。
4. 在 film.js 制作几何模型、灯光、镜头运动、时间轴、字幕和转场。分镜布局手动落实到代码，并非 Figma 一键自动转视频。
5. 浏览器检查四个镜头，按 30fps 导出 450 张 JPEG。
6. 系统视频编码器合成 H.264 MP4，并加入原创音轨；检查时长、分辨率、帧率和音视频轨道。
7. GitHub 保存源码，通过 Pull Request 审核修改。

## 分镜

| 时间 | 画面 | 意图 |
|---|---|---|
| 0–4s | 深色背景，手机转动揭幕 | 产品登场 |
| 4–8s | 明亮背景，镜头推近摄像模组 | 影像能力概念 |
| 8–12s | 芯片旋转，功能标题出现 | 性能概念 |
| 12–15s | 手机与品牌收尾 | 记忆点 |

## 预览

在项目目录运行 `python3 -m http.server 8000`，然后打开 `http://127.0.0.1:8000`。网页支持播放、暂停、重新播放和拖动进度。

视频导出需要在仓库根目录运行 `python3 launch-film/production/server.py`，访问 `http://127.0.0.1:8766`，点击“导出视频帧”。随后运行 `python3 launch-film/production/score.py` 和 `swift -module-cache-path /tmp/nova-swift-cache launch-film/production/encode.swift`。编码脚本需要 macOS 的 AVFoundation。脚本默认输出到 `work/launch-film` 及 `launch-film`，重复导出前应将旧成片移走。

## 正式项目需要补充

品牌 Logo、准确产品模型与材质、真实参数、图片或实拍素材、最终文案，以及片长和分辨率要求。当前作品用于验证完整制作流程，未达到参考片的精细建模与商业精修水平。
