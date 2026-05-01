# ⚡ CleanUp your System — System Optimizer For My LENOVO LEGION 5

![Batch](https://img.shields.io/badge/Script-Batch_(.bat)-orange?style=for-the-badge&logo=windows-terminal)
![Hardware](https://img.shields.io/badge/Target-Legion_Series-blue?style=for-the-badge&logo=lenovo)
![Windows](https://img.shields.io/badge/OS-Windows_10%2F11-0078D6?style=for-the-badge&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**CleanUp your System** is a high-performance system maintenance script specifically tuned for modern gaming laptops and developer workstations. Originally designed for the **Lenovo Legion 5 (i5-13450HX | RTX 4060 | NVMe SSD)**, it performs a deep 9-stage cleanup of temporary files, developer caches, browser data, and graphics subsystems — keeping your hardware running at peak performance.

---

## 📋 Table of Contents

- [✨ Features](#-features)
- [⚠️ Prerequisites](#️-prerequisites)
- [📥 Installation](#-installation)
- [🚀 How to Run](#-how-to-run)
- [🔧 What It Does (9 Stages)](#-what-it-does-9-stages)
- [📊 Post-Optimization Report](#-post-optimization-report)
- [📄 License](#-license)
- [👨‍💻 Author](#-author)

---

## ✨ Features

| Icon | Feature | Description |
|:----:|---------|-------------|
| 🧹 | **Deep Temp Cleanup** | Flushes both system (`C:\Windows\Temp`) and user (`%temp%`) temporary files |
| 📦 | **Developer Cache Purge** | Safely cleans `npm`, `pip`, and `Ollama` logs without affecting your local AI models |
| 🔄 | **Windows Update Cache** | Stops the Update service, clears the `SoftwareDistribution` download cache, and restarts it |
| 🎮 | **GPU Shader Refresh** | Rebuilds **NVIDIA DXCache** and **DirectX Shader Cache** to eliminate stuttering |
| 🌐 | **Browser Deep Clean** | Cleans Chrome & Edge caches across **all profiles** (not just Default) |
| 🗑️ | **Recycle Bin Cleanup** | Empties the Recycle Bin automatically |
| 🌍 | **DNS Cache Flush** | Clears stale DNS resolver entries for cleaner network lookups |
| 🖼️ | **Thumbnail & Icon Cache** | Properly kills `explorer.exe` to unlock and delete cache `.db` files, then restarts it |
| 💾 | **NVMe SSD TRIM** | Executes native TRIM commands for long-term SSD health and speed |
| 📝 | **Smart Logging** | Appends detailed reports to `Cleanup_Report.txt` on your Desktop (preserves history) |
| 📊 | **Space Reclaimed Report** | Shows exactly how much disk space was freed after cleanup |
| 📶 | **Visual Progress Bar** | Displays a real-time progress bar with percentage for each step |
| ⚠️ | **Error Tracking** | Logs warnings for any operations that fail, with a summary at the end |

---

## ⚠️ Prerequisites

Before running the script, make sure you have:

> ✅ **Windows 10 or Windows 11**
>
> ✅ **Administrator privileges** — the script modifies system-level caches and services
>
> ✅ **Git installed** *(only if you want to clone the repo — otherwise just download the file)*

---

## 📥 Installation

### Option 1: 🔗 Git Clone (Recommended)

Open **Command Prompt**, **PowerShell**, or **Git Bash** and run:

```bash
git clone https://github.com/mogdho/CleanUp-your-system.git
```

This will create a folder called `CleanUp-your-system` on your computer containing the `cleanup.bat` file.

```
CleanUp-your-system/
├── cleanup.bat      ← The main script
├── README.md
└── LICENSE
```

### Option 2: 📦 Direct Download

1. Go to the [**repository page**](https://github.com/mogdho/CleanUp-your-system)
2. Click the green **`<> Code`** button
3. Select **`Download ZIP`**
4. Extract the ZIP file anywhere on your PC

---

## 🚀 How to Run

Follow these simple steps:

1. 📂 **Navigate** to the folder where `cleanup.bat` is located

2. 🖱️ **Right-click** on `cleanup.bat`

3. 🛡️ Select **"Run as Administrator"**

   > 💡 **Tip:** If you see a Windows SmartScreen warning, click **"More info"** → **"Run anyway"**

4. ⏳ **Sit back** and watch the 9-stage optimization process run automatically

5. ✅ **Done!** Check the results on screen and find the full report on your Desktop

---

## 🔧 What It Does (9 Stages)

```
 [████████████████████████████████████░░░░░] 89%
```

| Step | Stage | What Gets Cleaned |
|:----:|-------|-------------------|
| 1/9 | 🧹 **System & User Temp** | All files in `%temp%` and `C:\Windows\Temp` |
| 2/9 | 📦 **Developer & AI Cache** | npm cache, pip cache, Ollama logs |
| 3/9 | 🔄 **Windows Update Cache** | `SoftwareDistribution\Download` folder |
| 4/9 | 🎮 **GPU Shader Cache** | NVIDIA DXCache, DirectX D3DSCache |
| 5/9 | 🌐 **Browser Cache** | Chrome & Edge caches (all profiles) |
| 6/9 | 🗑️ **Recycle Bin** | All deleted files in the Recycle Bin |
| 7/9 | 🌍 **DNS Cache** | Stale DNS resolver entries |
| 8/9 | 🖼️ **Thumbnail & Icon Cache** | `thumbcache_*.db` and `iconcache_*.db` |
| 9/9 | 💾 **NVMe SSD TRIM** | Optimizes SSD block allocation |

---

## 📊 Post-Optimization Report

Once the script finishes, you'll see:

- 📏 **Space Reclaimed** — exactly how much storage was freed (in MB or GB)
- ⚠️ **Warning Count** — how many operations had issues (if any)
- ⏱️ **System Uptime** — how long since your last reboot
- 📄 **Full Log** — saved to `Cleanup_Report.txt` on your Desktop

> **⚠️ Note:** Browsers (Chrome/Edge) will be **closed** during Stage 5 to ensure a deep cache clean. **Save your work before running!**

> **⚠️ Note:** Windows Explorer will **briefly restart** during Stage 8 to clear locked thumbnail/icon cache files. Your taskbar will disappear for a moment — this is normal.

---

## 📄 License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

### 👨‍💻 Author

**Mogdho Paul**

🔗 GitHub: [github.com/mogdho](https://github.com/mogdho)
📂 Source: [CleanUp-your-system](https://github.com/mogdho/CleanUp-your-system)
