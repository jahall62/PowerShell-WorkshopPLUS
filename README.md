# Windows PowerShell Foundation Skills – WorkshopPLUS

Demo scripts for the Windows PowerShell Foundation Skills WorkshopPLUS. Each file in [`Modules`](Modules) holds the commands shown in that module's slides, in slide order.

## Get the scripts

**Option 1 – Clone with VS Code** (needs Git installed)

1. Open VS Code.
2. Press `Ctrl+Shift+P`, type **Git: Clone**, and press Enter.
3. Paste this repository's URL, then pick a folder to save it in.
4. Click **Open** when VS Code asks.

**Option 2 – Clone from a terminal**

```powershell
git clone https://github.com/jahall62/PowerShell-WorkshopPLUS.git
```

**Option 3 – Download ZIP** (no Git needed)

1. On this page, click **Code** → **Download ZIP**.
2. Extract the ZIP. Then unblock the files, because Windows marks downloaded files as coming from the internet:

```powershell
Get-ChildItem -Path .\PowerShell-WorkshopPLUS-main -Recurse | Unblock-File
```

## Run the demos

1. Install the **PowerShell** extension in VS Code. VS Code offers it automatically when you open this folder.
2. Open a module script from the `Modules` folder.
3. Select a line or a block, then press **F8** to run just that selection.

Each script starts with `return`, so pressing **F5** by accident runs nothing. Run the scripts one selection at a time.

The scripts also work in the Windows PowerShell ISE, where **F8** runs the selection in the same way. One exception: the `clean { }` block in M11 (Slide 10) needs PowerShell 7.3 or later.

### M10 setup and cleanup

In [M10-Scripts.ps1](Modules/M10-Scripts.ps1), select the entire **Setup** region and press **F8** before starting the slides. Use Windows PowerShell 5.1, preferably ISE for the ISE CPU-counter examples. Setup creates the supporting scripts in `C:\temp\Files`, resets the demo command bindings, and prepares execution policies. It stops if Group Policy controls execution policy.

Setup replaces these named demo files; **Cleanup deletes them**: `Sample.ps1`, `script.ps1`, `my script.ps1`, `ScriptParamExample.ps1`, `Temp.ps1`, `Downloaded.ps1`, `TestScript.ps1`, `RequiresTest.ps1`, and `PowerShell_Cert.cer`. Other files in the folder are left alone. `Downloaded.ps1` is marked as Internet-origin for the execution-policy examples.

Run the entire **Cleanup** region afterward, even if you stop partway through. Keep the same PowerShell session open: it holds the original policies, location, command bindings, and demo certificate reference. Cleanup removes the demo alias/function overrides, restores unrelated original bindings and the original Process/CurrentUser policies, and removes only the certificate created by this run, including its private key and CurrentUser trust entries. LocalMachine policies and certificate stores are not changed. Certificates left from older manual demos are not removed automatically.

After cleanup, Setup can be run again. Running Setup twice without cleanup is blocked so the original settings are not lost. Cleanup can be retried if it reports an error; do not close the session until it succeeds.

### If a script won't run

- **"running scripts is disabled on this system"**: the execution policy is blocking scripts. Running a selection with F8 still works. To see the current policy, run `Get-ExecutionPolicy -List`.
- **Managed (organization) computers** may enforce a policy through Group Policy that you can't change. Use F8 selections, or ask your administrator.

## Modules

| Module | Script |
|---|---|
| M01 – Introduction to PowerShell | [M01-IntroductionToPowerShell.ps1](Modules/M01-IntroductionToPowerShell.ps1) |
| M02 – Commands | [M02-Commands.ps1](Modules/M02-Commands.ps1) |
| M03 – Help | [M03-Help.ps1](Modules/M03-Help.ps1) |
| M04 – Objects | [M04-Objects.ps1](Modules/M04-Objects.ps1) |
| M05 – PowerShell Providers | [M05-PowerShellProviders.ps1](Modules/M05-PowerShellProviders.ps1) |
| M06 – Working with Types | [M06-WorkingWithTypes.ps1](Modules/M06-WorkingWithTypes.ps1) |
| M07 – Collections | [M07-Collections.ps1](Modules/M07-Collections.ps1) |
| M08 – Pipeline | [M08-Pipeline.ps1](Modules/M08-Pipeline.ps1) |
| M09 – Flow Control | [M09-FlowControl.ps1](Modules/M09-FlowControl.ps1) |
| M10 – Scripts | [M10-Scripts.ps1](Modules/M10-Scripts.ps1) |
| M11 – Functions | [M11-Functions.ps1](Modules/M11-Functions.ps1) |
| M12 – Modules | [M12-Modules.ps1](Modules/M12-Modules.ps1) |
| M13 – Remoting Basics | [M13-RemotingBasics.ps1](Modules/M13-RemotingBasics.ps1) |

## Lab computer names

Some commands use the workshop lab computer names (`DC`, `MS`, `Win10`). On your own system, replace them with your computer names, or with `localhost`.
