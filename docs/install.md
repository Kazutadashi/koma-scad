# Install the tools

You need these tools only to make your own pieces, or the board, the
stands and the box. To print a ready-made set, you need nothing from here:
see [ready-made sets](ready-sets.md).

| Tool | What it is for | Needed for |
| --- | --- | --- |
| KomaSCAD's files | The models, presets and command-line tool | Everything |
| [OpenSCAD](https://openscad.org/downloads.html) | Builds the 3D models | Everything |
| [Python](https://www.python.org/downloads/) 3.10 or later | Runs `komascad.py`, which checks and exports the color 3MF files | Color pieces and color boards. Not for the one-color stands and box. |
| The bundled fonts | The lettering | Pieces, and the maker's mark |

KomaSCAD is tested with OpenSCAD 2021.01, the latest stable release.
Development snapshots are not tested. It needs Python 3.10 or later, and uses
only Python's standard library, so there is nothing else to install.

KomaSCAD is developed and tested on Linux. The tools are cross-platform and
the steps below cover Windows and macOS too, but those are less tested.
Please [report](https://github.com/Kazutadashi/koma-scad/issues)
anything that doesn't work.

## 1. Get KomaSCAD's files

1. On the [project page](https://github.com/Kazutadashi/koma-scad), click the
   green **Code** button, then **Download ZIP**.
2. Unzip it somewhere easy to find, such as your Documents folder. You get a
   folder named `koma-scad-main`. This guide calls it **the KomaSCAD folder**.

If you use Git, you can clone the repository instead; it makes updating
easier, but it is not required.

## 2. Install OpenSCAD

Download it from [openscad.org/downloads](https://openscad.org/downloads.html).

**Windows**

1. Run the installer and accept the defaults. OpenSCAD goes to
   `C:\Program Files\OpenSCAD\`.
2. That's all. The installer does not add OpenSCAD to the *PATH* (the list
   of places the command line looks for programs), so typing `openscad` in a
   terminal does nothing, and that is fine: KomaSCAD looks in
   `C:\Program Files\OpenSCAD\` by itself. You can still
   [add it to the PATH](#optional-add-openscad-to-the-path) if you want the
   `openscad` command.

   If you installed OpenSCAD somewhere else, tell KomaSCAD where it is with
   `--openscad` on each command:

   ```bat
   py komascad.py check shogi pawn --openscad "D:\Apps\OpenSCAD\openscad.com"
   ```

   Or set it once for the whole terminal session, so you can leave out
   `--openscad`:

   ```bat
   set OPENSCAD=D:\Apps\OpenSCAD\openscad.com
   ```

   In PowerShell, type `$env:OPENSCAD = "D:\Apps\OpenSCAD\openscad.com"`
   instead. Use `openscad.com`, not `openscad.exe`: the `.com` file is the
   command-line version, which shows OpenSCAD's messages.

**macOS**

1. Open the `.dmg` and drag **OpenSCAD** to **Applications**.
2. If macOS refuses to open it the first time, right-click OpenSCAD and
   choose **Open**.
3. KomaSCAD finds it in **Applications** by itself. If you put it
   somewhere else, give its location with `--openscad`:

   ```bash
   python3 komascad.py check shogi pawn --openscad /path/to/OpenSCAD.app/Contents/MacOS/OpenSCAD
   ```

**Linux**

Install it with your package manager, which puts `openscad` on the PATH:

```bash
sudo apt install openscad        # Debian, Ubuntu
sudo dnf install openscad        # Fedora
sudo pacman -S openscad          # Arch
```

Or download the AppImage from openscad.org, make it executable, and pass its
path with `--openscad`. The Flatpak version cannot be started as `openscad`,
so use the package or the AppImage for the command-line tool.

To check it, start OpenSCAD and look at **Help → About**: it should say
2021.01 or newer.

### Optional: add OpenSCAD to the PATH

When you type a command such as `openscad` in a terminal, the system looks
for a program with that name in a list of folders. That list is the *PATH*.
If OpenSCAD's folder is not on the list, the terminal says it cannot find the
program, even though OpenSCAD is installed.

KomaSCAD does not need this for a default install, because it also looks in
the default folder. Add OpenSCAD to the PATH if you installed it somewhere
else and don't want to type `--openscad` on every command, or if you want to
run `openscad` yourself from a terminal.

**Windows**

1. Press the Windows key, type `environment variables`, and open
   **Edit environment variables for your account**.
2. Under **User variables**, select **Path** and click **Edit**.
3. Click **New** and type the folder that holds OpenSCAD, for example
   `C:\Program Files\OpenSCAD`. Type the folder, not the program file.
4. Click **OK** in each window.
5. Close the terminal and open a new one. A terminal reads the PATH only when
   it starts.

Check it by typing `openscad --version` in the new terminal. It should print
the OpenSCAD version.

**macOS**

Link the program into a folder that is already on the PATH:

```bash
sudo ln -s /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD /usr/local/bin/openscad
```

If `/usr/local/bin` does not exist, create it first with
`sudo mkdir -p /usr/local/bin`. Then open a new terminal and check it with
`openscad --version`.

**Linux:** the package manager does this for you.

To learn more about the PATH, see
[PATH (variable)](https://en.wikipedia.org/wiki/PATH_(variable)) on Wikipedia.

## 3. Install Python (for color exports)

**Windows:** install Python from
[python.org](https://www.python.org/downloads/windows/). On the first screen
of the installer, tick **Add python.exe to PATH**. On Windows you then type
`py` where these guides say `python3`.

**macOS:** install Python from
[python.org](https://www.python.org/downloads/macos/). Type `python3`.

**Linux:** Python 3 is almost always installed already. Type `python3`.

**Check it** in a terminal (see [below](#open-a-terminal-in-the-komascad-folder)):

```bash
python3 --version        # Windows: py --version
```

It should print `Python 3.10` or a higher number.

## 4. Install the fonts

The pieces are lettered in fonts that come with KomaSCAD, in the `fonts`
folder. Install all six; it takes a minute, and then every bundled set works.
[fonts/README.md](../fonts/README.md) says which set uses which font.

**Windows:** open the `fonts` folder, select all the `.ttf` files,
right-click and choose **Install** (or **Install for all users**).

**macOS:** double-click each `.ttf` file and click **Install Font**. Or select
them all in Finder and open them with Font Book.

**Linux:** copy them to your fonts folder and refresh the font cache:

```bash
mkdir -p ~/.local/share/fonts
cp fonts/*.ttf ~/.local/share/fonts/
fc-cache -f
```

Then restart OpenSCAD. It reads the font list only when it starts.

To check the fonts, open **Help → Font List** in OpenSCAD and type `Yuji` in the
search box. You should see **Yuji Syuku** and **Yuji Mai**. Check
**LXGW WenKai Mono** and **Kaisei Tokumin** the same way. On Linux you can
also run `fc-list | grep -i -e yuji -e wenkai`.

## Open a terminal in the KomaSCAD folder

The `komascad.py` commands are typed in a *terminal*, from inside the
KomaSCAD folder.

- **Windows:** open the KomaSCAD folder in File Explorer, click the address
  bar, type `cmd` and press Enter. (On Windows 11 you can also right-click
  inside the folder and choose **Open in Terminal**.)
- **macOS:** open **Terminal** (in Applications → Utilities). Type `cd `
  (with a space), drag the KomaSCAD folder onto the window, and press
  Return.
- **Linux:** right-click inside the folder in your file manager and choose
  **Open in Terminal**, or `cd` to it.

## 5. Check that everything works

In the terminal, in the KomaSCAD folder:

```bash
python3 komascad.py list
```

You should see a table of games: `shogi`, `shogi-learner`, `minishogi` and
so on. Then check one piece, which needs OpenSCAD and the fonts:

```bash
python3 komascad.py check shogi-learner pawn
```

It should end with `0 of 1 pieces fail`. If it says it cannot find
OpenSCAD, see [step 2](#2-install-openscad): OpenSCAD is not installed, or is
installed outside the default folder.

If you see `[WinError 2] The system cannot find the file specified`, your copy
of KomaSCAD is older than the automatic OpenSCAD search. Download the files
again (see [step 1](#1-get-komascads-files)), or add `--openscad` with the
path from [step 2](#2-install-openscad).
If a font is missing, go back to [step 4](#4-install-the-fonts).

## Next

- [Make your first piece](getting-started.md).
- [Print or change a whole set](user-guide.md).
- [Make the board, stands and box](whole-set.md).
