# Windows Gaming Time Tracker — Project Summary (No Tray Mode)

## 1. Core Requirement
Developed a Windows PowerShell script to track daily gaming time that:
- Persists across restarts.
- Displays total and session time.
- Provides alerts for extended play.

## 2. Base Version
Implemented a PowerShell GUI tracker that:
- Monitors selected game processes.
- Saves progress to %APPDATA%\GamingTime.json.
- Resets each day.

## 3. Voice Alerts
Added pleasant voice alerts using Microsoft Zira Desktop that trigger after 35 minutes.

## 4. Repeating Alerts
Modified to repeat the alert every 5 minutes after the 35-minute mark.

## 5. Session vs. Cumulative Tracking
Added two timers:
- SessionSeconds: reset on logon.
- CumulativeSeconds: persisted daily.
Displayed both values in the GUI.

## 6. Timer Stability
Resolved timer and GUI issues by ensuring WinForms timers and $script: scope variables update properly.

## 7. Foreground / Active Window Tracking
Integrated user32.dll functions:
- IsIconic() to skip minimized windows.
- GetForegroundWindow() to detect only active play.

## 8. Expanded Game Coverage and History Graph
Included major launchers (Steam, Epic, Xbox, Wargaming, War Thunder) and direct games.
Added daily log (%APPDATA%\GamingHistory.csv) and graph visualization using Windows Forms Chart.

## 9. Final Features Summary
| Feature | Description |
|----------|--------------|
| Session timer | Counts current session time |
| Cumulative timer | Persists daily total across logins |
| Alert logic | 35-minute initial + 5-minute repeats |
| Active play detection | Only counts when game window is foreground |
| Supported games | Fortnite, Minecraft, Roblox, AmongUs, Steam, Epic, Xbox, WGC, Gaijin |
| GUI | Displays timers + history chart |
| Storage | JSON + CSV history |

---

**Project Result:**  
A robust, voice-enabled PowerShell-based Gaming Tracker that measures real gaming engagement time, persists daily stats, provides pleasant reminders, and offers visual insights—all through a simple, always-on GUI window.
