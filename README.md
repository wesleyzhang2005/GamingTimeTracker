# 🎮 Windows Gaming Time Tracker (PowerShell)

A lightweight PowerShell tool that monitors **session and daily gaming time**, provides **friendly voice alerts**, and visualizes **play history** — all in a simple, always-on GUI.
The project purpose is for a teen gamer to know how long he is/has being playing.

---

## 🚀 Features

| Feature | Description |
|----------|-------------|
| **Session timer** | Tracks how long you’ve been playing during the current login session |
| **Daily cumulative timer** | Persists total playtime across restarts and multiple sessions |
| **Active play detection** | Counts time only when the game window is active and visible (not minimized or background) |
| **Voice alerts** | Announces after 35 minutes of session play and every 5 minutes after |
| **History chart** | Displays daily cumulative gaming totals over time |
| **Supported titles** | Fortnite, Minecraft, Roblox, Among Us, Steam, Epic Games Launcher, Xbox App, Wargaming Launcher, War Thunder |

---

## 🧩 How It Works

- Runs as a **Windows Forms GUI**.  
- Uses `user32.dll` (`GetForegroundWindow`, `IsIconic`) to detect active windows.  
- Tracks **session playtime** independently from **daily total**.  
- Stores:  
  - `GamingTime.json` → today’s totals  
  - `GamingHistory.csv` → historical daily minutes  
- Uses `System.Speech` for pleasant voice feedback.  
- Uses `System.Windows.Forms.DataVisualization` to display usage graphs.

---

## 📦 Installation

1. **Save the script**  
   Save the file as `GamingTracker.ps1` in a convenient location, for example:  
   ```
   C:\Scripts\GamingTracker.ps1
   ```

2. **Run it manually once**  
   Launch PowerShell as Administrator and test-run the script to ensure it displays the GUI and tracks time:  
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\GamingTracker.ps1"
   ```

3. **Set up automatic launch at logon (recommended)**  
   To have the tracker run automatically each time you log in:  
   - Press **Win + S**, type **Task Scheduler**, and open it.  
   - Click **Action → Create Task**.  
   - Under the **General** tab:  
     - Name: `Gaming Time Tracker`  
     - Check **Run only when user is logged on**  
   - Under the **Triggers** tab:  
     - Click **New → Begin the task: At log on**  
   - Under the **Actions** tab:  
     - Click **New → Start a program**  
     - In **Program/script**, enter:  
       ```
       powershell.exe
       ```  
     - In **Add arguments**, enter:  
       ```
       -ExecutionPolicy Bypass -File "C:\Scripts\GamingTracker.ps1"
       ```  
   - Click **OK** to save.  

   The tracker will now start automatically each time the user logs in, showing its GUI window.

---

## 🖥️ Usage

- The GUI shows **session** and **today’s total** playtime.  
- Click **View History** to view a graph of previous daily totals.  
- Close the window to stop tracking.  
- Data is stored under `%APPDATA%`.

---

## 📁 Data Files

| File | Purpose |
|------|----------|
| `%APPDATA%\GamingTime.json` | Tracks current day totals |
| `%APPDATA%\GamingHistory.csv` | Logs daily totals for chart display |

---

## 🔊 Alert Behavior

- First voice alert after **35 minutes of active session play**  
- Repeats **every 5 minutes** afterward  
- Uses **Microsoft Zira Desktop** voice for clear and friendly notifications  

---

## 🛠️ Requirements

- Windows 10 / 11  
- PowerShell 5.1 or later  
- .NET Framework 4.8 (installed by default on Windows 10+)  

---

## 📈 Example Output

```
Session: 00:42:15
Total today: 01:18:40
```

---

## 📜 License

MIT License — free for personal use and modification.
