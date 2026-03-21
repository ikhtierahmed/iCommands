# 🛠️ iCommands v2.8
**The Ultimate All-in-one Windows Management & Optimization Utility**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Download iCommands](https://img.shields.io/badge/Download-v2.8-blue)](https://github.com/ikhtierahmed/iCommands/raw/4d69ad5e5e77f9b64c381967509be94903895db7/iCommands.exe)

<p align="center">
  <img src="https://github.com/ikhtierahmed/iCommands/raw/841e0a8c65353ca5e8de4da738d3401e3871fb74/logo.png" width="200" alt="iCommands Logo">
</p>

iCommands is a powerful, lightweight administrative tool designed to simplify Windows maintenance, system repairs, and performance optimization into a single console interface.

---

## 📸 Interface Preview
<p align="center">
  <img src="https://github.com/user-attachments/assets/0e2ae3c2-17a1-4ecc-9123-e5e372d1510e" alt="iCommands v2.8 UI Dashboard" width="750">
</p>

---

## 🚀 Quick Download & Run
Click the button below to download the latest compiled executable directly:

[![Download iCommands](https://img.shields.io/badge/Download-iCommands.exe-blue?style=for-the-badge&logo=windows)](https://github.com/ikhtierahmed/iCommands/raw/4d69ad5e5e77f9b64c381967509be94903895db7/iCommands.exe)

> **⚠️ Admin Rights Required:** This tool performs deep system tasks. Please right-click the `.exe` and select **"Run as Administrator"** for full functionality.

---

## ✨ Key Features (v2.8)

- **🛡️ Smart Categorized UI:** Tools are now organized into **{Third-party}**, **{Windows}**, and **{System}** zones for safer navigation.
- **📊 Live Activity Logging:** Full audit trail with real-time log size display on the dashboard and an instant **[L]** view shortcut.
- **🧹 Self-Cleaning Engine:** Optimized to monitor log growth and perform a silent reset once the file hits **50 MB** to save disk space.
- **🚀 System Performance:** Real-time Windows Experience Index (WinSAT) assessment for CPU, RAM, and Disk.
- **🔍 Hardware Health:** S.M.A.R.T. status monitoring for SSD/HDD health and life-left percentage.
- **📦 WinGet Integration:** Search, install, and batch-upgrade all your Windows apps from one unified menu.
- **🛠️ System Repair:** One-click SFC Scannow, Network resets, and "Reboot to BIOS/UEFI" functionality.

---

## 🛡️ Requirements
- **OS:** Windows 10 or 11 (64-bit)
- **Engine:** Built with Batch & PowerShell for maximum compatibility and zero-footprint performance.

---

## 👨‍💻 Author
**bY - IAN (Md. Ikhtier Ahmed)**

*Disclaimer: This tool is provided "as is". Use at your own risk. Always back up important data before running deep system optimizations.*

---

## ⚡ Instant Execution (PowerShell)
No download required. Copy and paste this command into an **Administrator PowerShell** window to launch iCommands v2.8 instantly:

```powershell
irm [https://github.com/ikhtierahmed/iCommands/raw/4d69ad5e5e77f9b64c381967509be94903895db7/iCommands.exe](https://github.com/ikhtierahmed/iCommands/raw/4d69ad5e5e77f9b64c381967509be94903895db7/iCommands.exe) -OutFile "$env:TEMP\iCommands.exe"; Start-Process "$env:TEMP\iCommands.exe"
