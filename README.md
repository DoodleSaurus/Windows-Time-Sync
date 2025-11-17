# Windows-Time-Sync

A tiny, safe helper to quickly re-sync your Windows clock when your motherboard/CMOS won't keep the time across power cycles.

If your system clock always resets to the last boot time (forcing you to open BIOS or Windows settings each boot), this repository provides a simple, two-click solution: run a small script as Administrator and the Windows Time service is re-registered and forced to sync.

---

## Contents
- `time-sync.bat` — the script to stop/re-register/start the Windows Time service and force a sync.
- `README.md` — this file.

---

## How it works (short)
1. Stops the Windows Time service (w32time).
2. Unregisters and re-registers the service to ensure its configuration is correct.
3. Starts the service again.
4. Forces a time resynchronization with Windows time servers using `w32tm /resync /force`.

The script uses built-in Windows commands and requires Administrator privileges.

---

## time-sync.bat (included)
```batch
@echo off
echo Syncing time with Windows time server...

:: Stop the Windows Time service
net stop w32time >nul 2>&1

:: Re-register the time service
w32tm /unregister >nul 2>&1
w32tm /register >nul 2>&1

:: Start the Windows Time service
net start w32time >nul 2>&1

:: Force time synchronization
w32tm /resync /force

echo Time sync complete.
pause
```

---

## Usage

### Quick (two-click) — Recommended
1. Place `time-sync.bat` somewhere convenient (Desktop or a dedicated utilities folder).
2. Right-click `time-sync.bat` → Create shortcut.
3. Right-click the shortcut → Properties → Shortcut → Advanced... → check **Run as administrator** → OK → Apply.
4. Double-click the shortcut. Approve the UAC prompt once, and the script runs and syncs the time.

> Tip: Remove the `pause` line in the script if you want the script window to close automatically after syncing.

### Run automatically at logon/startup (no UAC prompt)
Use Task Scheduler to run the script elevated without prompting:
1. Open Task Scheduler → Create Task.
2. Give the task a name and check **Run with highest privileges**.
3. On the Triggers tab add a trigger: **At log on** (or **At startup**).
4. On the Actions tab add: **Start a program** → Browse to `time-sync.bat`.
5. Save. The task will run elevated on your chosen trigger.

---

## Troubleshooting & notes

- Administrator required: The script must be run elevated to stop/start services and re-register w32time.
- Firewall / Network: Time sync uses NTP (UDP port 123). Ensure your internet connection and firewall rules allow NTP traffic.
- Service disabled: If the Windows Time service is disabled, enable it in Services (services.msc) or via:
  sc config w32time start= auto
- Check logs: Look in Event Viewer → Windows Logs → System for w32time or Service Control Manager messages if sync fails.
- CMOS battery: If the real root cause is a failing CMOS battery, replace the coin cell (commonly CR2032) on the motherboard — this often permanently fixes clock retention across power cycles.
- Windows versions: The commands used are standard on modern Windows (7/8/10/11). Very old or heavily modified systems may behave differently.

---

## Customization

- Remove the final `pause` to avoid the window waiting for input.
- To log output to a file, append redirection, for example:
  w32tm /resync /force >> "%~dp0time-sync.log" 2>&1

- If you want a PowerShell version, or an installer/shortcut generator, open an issue or request it here and I'll add it.

---

## Security & safety
- The script performs common administrative operations for the Windows Time service. Inspect the script before running it and only run scripts from sources you trust.
- Re-registering and restarting the Windows Time service is safe on normal Windows installations, but avoid running scripts with elevated privileges from untrusted origins.

---

## License
Use freely. You do you, pookieヾ(•ω•`)o


