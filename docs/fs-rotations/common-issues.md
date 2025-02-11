# Common Issues

This document provides solutions to the most common issues encountered when setting up or running Sylvanas. Follow these instructions to resolve any problems you may face.
note
If your issue isn’t listed here, feel free to open a ticket on our Discord server for additional assistance.

## Common Errors and Fixes[​](https://docs.project-sylvanas.net/docs/<#common-errors-and-fixes> "Direct link to Common Errors and Fixes")

### ERROR 1: Network Error[​](https://docs.project-sylvanas.net/docs/<#error-1-network-error> "Direct link to ERROR 1: Network Error")

![](https://downloads.project-sylvanas.net/1730373186978-PIC1.png) If you encounter a network error, it’s often due to antivirus or firewall settings blocking Sylvanas. To fix this issue, ensure your antivirus software or firewall isn't blocking the Sylvanas connection.
note
This issue is especially common for users in China . If you’re located in China, you may need to use a VPN or adjust your network settings for optimal connection stability.

### ERROR 2: Disable Test Signing Mode in Windows[​](https://docs.project-sylvanas.net/docs/<#error-2-disable-test-signing-mode-in-windows> "Direct link to ERROR 2: Disable Test Signing Mode in Windows")

![](https://downloads.project-sylvanas.net/1730373194057-PIC2.png)
If your system is in test signing mode, it may interfere with Sylvanas. Here’s how to disable it:

- Open Command Prompt as Administrator.
- Enter the following command: `bcdedit -set TESTSIGNING OFF`
- Restart your computer to apply the change.

### ERROR 3: Enable Secure Boot or Disable Hyper-V in Windows Settings[​](https://docs.project-sylvanas.net/docs/<#error-3-enable-secure-boot-or-disable-hyper-v-in-windows-settings> "Direct link to ERROR 3: Enable Secure Boot or Disable Hyper-V in Windows Settings")

![](https://downloads.project-sylvanas.net/1730373199302-PIC3.png)
Sylvanas may not function correctly if Hyper-V is enabled or if Secure Boot is disabled. To address this:
Option 1: Disable Hyper-V

- Open Command Prompt as Administrator.
- Enter the following command:

```
bcdedit /set hypervisorlaunchtype off
```

- Restart your computer.

Option 2: Enable Secure Boot

- Restart your computer and enter the BIOS/UEFI settings (usually by pressing F2, F10, or DEL during startup).
- Look for the Secure Boot option and ensure it is enabled.
- Save changes and restart.

If you continue to experience issues after these steps, please reach out via Discord for further support.

### ERROR 4: WoW privilege[​](https://docs.project-sylvanas.net/docs/<#error-4-wow-privilege> "Direct link to ERROR 4: WoW privilege")

![](https://downloads.project-sylvanas.net/1730373336808-idkxd.png)
Do you remember that pixel bot that you opened last week? Well, probably its weird bypass is messing with Sylvanas 😆.
note
Open WoW normally and this issue should be fixed.

### ERROR 5: Antivirus Blocking Injection[​](https://docs.project-sylvanas.net/docs/<#error-5-antivirus-blocking-injection> "Direct link to ERROR 5: Antivirus Blocking Injection")

![](https://downloads.project-sylvanas.net/1730373209062-pic5.png)
To fix this, just go to Windows Security settings and disable Real-Time protection.

### ERROR 6: Game Freezes After Alt-Tabbing (DirectX Reset)[​](https://docs.project-sylvanas.net/docs/<#error-6-game-freezes-after-alt-tabbing-directx-reset> "Direct link to ERROR 6: Game Freezes After Alt-Tabbing (DirectX Reset)")

When users switch out of the game and come back (Alt+Tab), the game freezes, resets DirectX 12, and the cheat stops working. If they try to inject again, the game crashes. Minimizing the game requires starting a new session later.
**Source of the Issue:** Blizzard’s mishandling of game compatibility on some Windows versions. Since Blizzard hasn’t resolved this, we’ve created a simple hotfix using a trusted method from NVIDIA.
**Hotfix Steps:** Instead of doing manual registry editing, NVIDIA provides two pre-made macros that make it easier for you: ✅

1. **Download and run the registry macro to apply the fix:** This disables Multi-Plane Overlay (MPO), which is a setting that can cause issues when switching between full-screen apps.
2. **Restart your PC.**
3. If you experience any issues or want to undo the change, the second macro provided in the guide will safely revert the fix.

**Why this Works:** Disabling Multi-Plane Overlay helps stabilize the way the game interacts with the system when switching between windows, preventing the freezing and crashing issues.
Additionally, try disabling G-Sync if the problem persists.

### ERROR 7: Loader Window Hidden or Disappearing[​](https://docs.project-sylvanas.net/docs/<#error-7-loader-window-hidden-or-disappearing> "Direct link to ERROR 7: Loader Window Hidden or Disappearing")

On some Windows versions, the loader window can go black or hide behind other windows, making it hard to interact with. This often happens if you have multiple windows open and switch to another window before attaching the loader to the taskbar.
**What’s Happening:** The program doesn’t immediately appear in the taskbar when launched. If another window gets in front of the loader before you manually click on it, the loader may disappear into the background or lose its window position. This is due to a complex interaction between window rendering and OS management.
We prioritize security and functionality over visual clunkiness, so addressing this issue is tricky, and it might never be fully resolved. After all, this is a hacking tool (not exactly Microsoft-certified development 😆).
**Recommendations:**

- Minimize the number of open windows or keep them hidden when launching the loader.
- Wait for the program to fully load before interacting with any other window.
- Click the loader window once to attach it to the taskbar and prevent it from hiding in the background.

Thanks for understanding—we’re working on bigger priorities for now.
If your issue isn’t resolved by any of the steps listed here, don’t hesitate to contact us on Discord. We’ll be happy to help!
[[getting-started]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Common Errors and Fixes](https://docs.project-sylvanas.net/docs/<#common-errors-and-fixes>)
  - [ERROR 1: Network Error](https://docs.project-sylvanas.net/docs/<#error-1-network-error>)
  - [ERROR 2: Disable Test Signing Mode in Windows](https://docs.project-sylvanas.net/docs/<#error-2-disable-test-signing-mode-in-windows>)
  - [ERROR 3: Enable Secure Boot or Disable Hyper-V in Windows Settings](https://docs.project-sylvanas.net/docs/<#error-3-enable-secure-boot-or-disable-hyper-v-in-windows-settings>)
  - [ERROR 4: WoW privilege](https://docs.project-sylvanas.net/docs/<#error-4-wow-privilege>)
  - [ERROR 5: Antivirus Blocking Injection](https://docs.project-sylvanas.net/docs/<#error-5-antivirus-blocking-injection>)
  - [ERROR 6: Game Freezes After Alt-Tabbing (DirectX Reset)](https://docs.project-sylvanas.net/docs/<#error-6-game-freezes-after-alt-tabbing-directx-reset>)
  - [ERROR 7: Loader Window Hidden or Disappearing](https://docs.project-sylvanas.net/docs/<#error-7-loader-window-hidden-or-disappearing>)
