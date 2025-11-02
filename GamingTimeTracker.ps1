Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# --- WinAPI for window state ---
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr hWnd);
}
"@

# --- File paths ---
$storageFile = "$env:APPDATA\GamingTime.json"
$historyFile = "$env:APPDATA\GamingHistory.csv"

# --- Game + Launcher processes to track ---
$script:games = @(
    "Fortnite","Minecraft","Roblox","AmongUs","chrome"          # direct games
    "steam","epicgameslauncher","gamingservices",      # launchers
    "xboxappservices","wgc",                           # Wargaming
    "launcher","aces"                                  # War Thunder
)

# --- Load cumulative ---
if (Test-Path $storageFile) {
    $data = Get-Content $storageFile | ConvertFrom-Json
} else {
    $data = @{ Date=(Get-Date).ToString("yyyy-MM-dd"); CumulativeSeconds=0 }
}
$script:data = $data

# Reset if new day
if ($script:data.Date -ne (Get-Date).ToString("yyyy-MM-dd")) {
    # Log yesterday
    "$($script:data.Date),$([math]::Round($script:data.CumulativeSeconds/60))" | Out-File -Append $historyFile
    $script:data.Date = (Get-Date).ToString("yyyy-MM-dd")
    $script:data.CumulativeSeconds = 0
}

# --- Session vars ---
$script:SessionSeconds = 0
$script:LastAlert = 0

# --- GUI ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Gaming Time Tracker"
$form.Size = [Drawing.Size]::new(350,160)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Font = [Drawing.Font]::new("Segoe UI",12)
$label.Location = [Drawing.Point]::new(10,10)
$label.AutoSize = $true
$form.Controls.Add($label)

$buttonGraph = New-Object System.Windows.Forms.Button
$buttonGraph.Text = "View History"
$buttonGraph.Location = [Drawing.Point]::new(10,80)
$buttonGraph.AutoSize = $true
$form.Controls.Add($buttonGraph)

# --- Graph Window ---
$buttonGraph.Add_Click({
    $gForm = New-Object System.Windows.Forms.Form
    $gForm.Text = "Gaming History"
    $gForm.Size = [Drawing.Size]::new(600,400)

    $chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $chart.Dock = "Fill"
    $gForm.Controls.Add($chart)

    $chart.ChartAreas.Add("area")

    $series = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $series.ChartType = "Line"
    $series.BorderWidth = 3
    $chart.Series.Add($series)

    if (Test-Path $historyFile) {
        foreach ($line in Get-Content $historyFile) {
            $parts = $line -split ","
            $series.Points.AddXY($parts[0], [int]$parts[1])
        }
    }

    $gForm.ShowDialog()
})

# --- Timer ---
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000

$timer.Add_Tick({
    $active = $false
    $fg = [WinAPI]::GetForegroundWindow()

    foreach ($name in $script:games) {
        $proc = Get-Process -Name $name -ErrorAction SilentlyContinue |
                Where-Object { $_.MainWindowHandle -ne 0 }

        foreach ($p in $proc) {
            if ($p.MainWindowHandle -eq $fg -and -not [WinAPI]::IsIconic($p.MainWindowHandle)) {
                $active = $true; break
            }
        }
        if ($active) { break }
    }

    if ($active) {
        $script:SessionSeconds++
        $script:data.CumulativeSeconds++
    }

    # Alerts
    if ($script:SessionSeconds -ge 35*60 -and
        $script:SessionSeconds -ge $script:LastAlert + 5*60) {
        
        $s = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $s.SelectVoice("Microsoft Zira Desktop")
        $s.Rate = -1
        $s.Volume = 90
        $s.Speak("You've been gaming over thirty five minutes. Take a break.")
        $script:LastAlert = $script:SessionSeconds
    }

    # Save
    $script:data | ConvertTo-Json | Set-Content $storageFile

    # UI Update
    $fmt = { param($sec) "{0:00}:{1:00}:{2:00}" -f [math]::Floor($sec/3600), [math]::Floor(($sec%3600)/60), ($sec%60) }
    $label.Text = "Session: $(& $fmt $script:SessionSeconds)`nToday: $(& $fmt $script:data.CumulativeSeconds)"
})

$timer.Start()
$form.ShowDialog()
