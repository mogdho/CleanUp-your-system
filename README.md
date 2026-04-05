# ⚡ CleanUp your System - An Optimizer [Core 3.1]
![Batch](https://img.shields.io/badge/Script-Batch_(.bat)-orange?style=for-the-badge&logo=windows-terminal)
![Hardware](https://img.shields.io/badge/Target-Legion_Series-blue?style=for-the-badge&logo=lenovo)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**CleanUp your System** is a high-performance system maintenance script specifically tuned for modern gaming laptops and developer workstations. Originally designed for the **Lenovo Legion 5 (i5-13450HX | RTX 4060)**, it provides a deep sanitization of temporary files, developer caches, and graphics subsystems to ensure peak hardware responsiveness.

### ✨ Advanced Features
* **Developer & AI Cache Purge:** Safely cleans `npm`, `pip`, and `Ollama` logs without affecting your local models.
* **Graphics Subsystem Refresh:** Rebuilds **NVIDIA DXCache** and **DirectX Shader Cache** to eliminate stuttering in AAA titles.
* **Storage Maintenance:** Executes native **NVMe SSD TRIM** commands via PowerShell to maintain long-term drive health and speed.
* **Update Sanitization:** Flushes the Windows Update `SoftwareDistribution` cache to recover gigabytes of lost storage.
* **Auto-Reporting:** Generates a detailed `Cleanup_Report.txt` on your Desktop after every run for transparency.

---

### ⚠️ Pre-requisites
* **Administrator Privileges:** This script modifies system-level caches (NVIDIA, Windows Update) and requires Admin rights to function.
* **Target OS:** Optimized for Windows 10/11.

---

### 🛠️ Execution Guide
1. Download the `cleanup.bat` file.
2. **Right-click** on the file and select **Run as Administrator**.
3. Follow the 6-stage automated process:
   - [1/6] System & User Temp Flush
   - [2/6] Dev Environment (NPM/PIP/Ollama) Optimization
   - [3/6] Storage Sense & Update Cache Cleanup
   - [4/6] RTX Shader Cache Rebuild
   - [5/6] Browser Sanitization (Chrome/Edge)
   - [6/6] NVMe SSD TRIM Execution

---

### 📊 Post-Optimization Report
Once complete, the script displays your current **System Uptime** and saves a comprehensive log to your Desktop containing timestamps and success status for each module.

> **Note:** Browsers (Chrome/Edge) will be closed during Stage 5 to ensure a deep cache clean. Please save your work before running.

---

### 📄 License
Distributed under the **MIT License**.

---

### 🔗 Download/Source link
- Download/Source link - https://github.com/mogdho/CleanUp-your-system
