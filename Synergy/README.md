# Synergy ↔ AeroSpace interop

Context for an agent picking this task up cold. Read it fully before touching
anything — several obvious-looking moves here have already been tried and
disproved, and one of them (restarting Synergy.app on macOS) breaks the user's
keyboard sharing.

---

## 1. The goal

One shortcut, `Ctrl+Alt+\`, pressed on **foxtrot's** (NixOS) physical keyboard,
should behave as a toggle:

| State when pressed | Desired result |
| --- | --- |
| Cursor on another machine | Move the cursor to `alpha` (the Mac) |
| Already on `alpha` | Focus the **Sidecar** display |
| Already on Sidecar | Focus the **Built-in** display |

On non-macOS machines the same shortcut should just switch to `alpha`.

The macOS half is a monitor-focus toggle handled by AeroSpace. Because `alpha`
has exactly two monitors, `focus-monitor --wrap-around next` *is* the toggle —
no script needed.

### Known, accepted deviation

Synergy hotkeys have no conditional logic. The server cannot test "am I already
on alpha?", so a press from another machine switches to `alpha` **and** toggles
a monitor. You land on `alpha`, just on the alternating screen. The user has
been told; making it exact would need the Mac to infer recent screen-entry from
the Synergy client log, which was judged too fragile.

---

## 2. Topology

Synergy 3.6.0. One server, several clients.

| Screen name | Host | Role | OS |
| --- | --- | --- | --- |
| `foxtrot-3a733ea5` | foxtrot @ 192.168.1.29 | **server** (owns the keyboard) | NixOS, X11 + i3 + GDM |
| `alpha-0ea09446` | alpha | client | macOS 26 (Darwin 25.5) |
| `juliett-9a2757a3` | — | client | — |
| `india-3e33d65f` | — | client | — |
| `golf-7126e0b0` | — | client | — |

The server runs as a **Flatpak** (`com.symless.synergy`). The Mac connects to
`192.168.1.29:24800`.

**The single most important consequence of this topology:** hotkeys in
`section: options` are matched by the *server*, against the *server's* physical
keyboard, and the server **consumes** them. They never arrive on macOS as real
keystrokes — not even when the cursor is already on `alpha`. So AeroSpace cannot
bind `Ctrl+Alt+\` for the Synergy path; the server must *synthesize and send* a
separate key. That is why F19 exists in this design.

`alpha`'s own built-in keyboard is a completely separate path: Synergy is not
involved, and AeroSpace sees `ctrl-alt-backslash` natively. Both paths are bound.

---

## 3. The repo: same repo, different branch per device

Both machines have `~/.dotfiles` pointing at `git@arepa:arepaFlipper/.dotfiles.git`,
but each device sits on **its own branch**:

| Device | Branch |
| --- | --- |
| alpha (macOS) | `Mac` |
| foxtrot (NixOS) | `NixOS` |

**Editing a file under `NixOS/` from the Mac does not change foxtrot.** The two
checkouts are independent working trees on different branches. An earlier
session edited `NixOS/.config/home-manager/configuration.nix` on the Mac; the
user had to redo the change by hand on foxtrot before rebuilding.

Rule of thumb: **make each change on the device that consumes it**, on that
device's branch. Use `ssh NixOS` (aliased, key-based, passwordless — the user
has authorized this) to edit foxtrot directly.

### Deployment is via GNU Stow symlinks

On foxtrot, the whole config *directory* is a symlink into the repo:

```
~/.var/app/com.symless.synergy/config/Synergy
  -> ../../../../.dotfiles/Synergy/.var/app/com.symless.synergy/config/Synergy
```

So editing the repo file *is* editing the live server config. Same pattern on
the Mac for `~/.config/aerospace` → `~/.dotfiles/Aerospace/.config/aerospace`.
The files themselves are regular files; the parent dir is the symlink. `ls -la`
on the file looks non-symlinked — use `readlink -f` on it to see the truth.

---

## 4. Files involved

| File | Device | Role |
| --- | --- | --- |
| `Synergy/.var/app/com.symless.synergy/config/Synergy/synergy.conf` | foxtrot | **The live server config.** Hotkeys live in `section: options`. |
| `Aerospace/.config/aerospace/aerospace.toml` | alpha | AeroSpace bindings + monitor assignment |
| `NixOS/.config/home-manager/configuration.nix` | foxtrot | NixOS system packages (`xorg.xmodmap`, `xdotool` added here) |
| `~/Library/Preferences/Synergy/local.json` | alpha | Client settings incl. `diagnostic.level` (log verbosity) |
| `~/Library/Preferences/Synergy/synergy.conf` | alpha | **STALE DECOY — see §7.** Not used; the Mac is a client. |

### Logs

| Log | Path |
| --- | --- |
| Server (foxtrot) | `~/.var/app/com.symless.synergy/.local/state/Synergy/synergy.log` |
| Client (alpha) | `~/Library/Logs/Synergy/synergy.log` |

Server currently runs at `--debug DEBUG2`; it rotates to `synergy.log.old` at
10 MB and can burn through that in minutes. Grep, don't tail.

---

## 5. Current configuration

**foxtrot — `synergy.conf`, `section: options`:**

```
keystroke(Control+Alt+Backslash) = switchToScreen(alpha-0ea09446) ; keystroke(F19)
```

Actions before `;` fire on key-down, after `;` on key-up. Synergy expands
`keystroke(F19)` into `keyDown(F19)` on activate and `keyUp(F19)` on deactivate.

**alpha — `aerospace.toml`, `[mode.main.binding]`:**

```toml
ctrl-alt-backslash = 'focus-monitor --wrap-around next'   # Mac's own keyboard
f19          = 'focus-monitor --wrap-around next'          # from Synergy
ctrl-f19     = 'focus-monitor --wrap-around next'
alt-f19      = 'focus-monitor --wrap-around next'
ctrl-alt-f19 = 'focus-monitor --wrap-around next'
cmd-f19      = 'focus-monitor --wrap-around next'
cmd-alt-f19  = 'focus-monitor --wrap-around next'
```

The modifier variants were defensive (in case the key arrived decorated). The
server log later proved F19 is sent undecorated, so they are redundant but
harmless. A commented `cmd-alt-backslash` fallback sits below them.

Monitors on alpha: `1 | Sidecar Display (AirPlay)`, `2 | Built-in Retina Display`
(index 2 is the macOS *main* display). `[workspace-to-monitor-force-assignment]`
pins workspaces by **display-name regex** with a `'main'` fallback rather than
`main`/`secondary`, so it survives rearranging displays.

Modifier translation, established from the user's own pre-existing config: Synergy
`Meta` → macOS **Command**, `Alt` → **Option**, `Ctrl` → **Control**.

---

## 6. Where the investigation actually stands

### PROVEN WORKING — do not re-debug these

1. **AeroSpace's side.** Injecting F19 locally toggles the monitor:
   ```bash
   aerospace list-monitors --focused
   osascript -e 'tell application "System Events" to key code 80'   # 80 = F19
   aerospace list-monitors --focused    # flips Built-in <-> Sidecar
   ```
2. **The server config parses.** Verified headless:
   ```bash
   ssh NixOS 'timeout 6 flatpak run --command=/app/lib/com.symless.synergy/synergy-core \
     com.symless.synergy server -f --no-tray -c ~/.var/app/com.symless.synergy/config/Synergy/synergy.conf \
     --name foxtrot-3a733ea5 --address 127.0.0.1:24999 --debug DEBUG1' 2>&1 | grep -i config
   # => "configuration read successfully"
   ```
   (The X screen error in that output is just from running headless. Ignore it.)
3. **The server sends F19.** This is the key evidence. Four real presses produced:
   ```
   activate actions
   hotkey: switchToScreen(alpha-0ea09446)
   hotkey: keyDown(F19)
   deactivate actions
   hotkey: keyUp(F19)
   ```
   So the `;` syntax works, the config is live, and F19 is genuinely transmitted.

### RULED OUT — with evidence

- **Stale server config.** Was real once: `synergy-core` started 10:01:00 and the
  stow sync wrote the file at 10:01:01.478, so it read the file 1.5 s too early.
  Fixed by SIGHUP reload. Symptom persisted → not the blocker.
- **F19 missing from foxtrot's X keymap.** False alarm: `xmodmap` was not
  installed, so the grep matched nothing and a missing binary was misread as a
  missing keysym. With the right cookie, `xdotool key F19` exits 0.
- **macOS Accessibility permission.** `com.symless.synergy` holds
  `kTCCServiceAccessibility` with `auth_value 2`. AeroSpace holds it too.
- **Modifiers held during release.** The log shows `keyDown(F19)`/`keyUp(F19)`
  undecorated, so this was wrong.
- **The `;` release-action syntax being unsupported in 3.6.** The log proves it fires.

### THE OPEN QUESTION

The server sends F19; the Mac never acts on it. Nobody has yet observed what the
**macOS client** does with the received F19, because the client log is at `INFO`
and key events are only logged at DEBUG.

Leading hypothesis, which also explains a second symptom the user reported —
**modifier keys appear dead in a keyboard tester when typing from foxtrot, while
ordinary characters work fine**:

> Synergy injects plain characters as Unicode text (needs no privilege), but
> modifiers and function keys require posting real keycodes/flags. If that second
> path is broken or denied for the `synergy-core` binary specifically — note it is
> a *separate binary* from the app bundle that holds the TCC grant, launched by
> launchd, so responsible-process attribution can differ — then letters work,
> modifiers die, and F19 is silently dropped. That matches every observation.

Worth trying: in System Settings → Privacy & Security → **Accessibility**, remove
Synergy entirely and re-add it (forces a fresh grant against the current binary).
Also add it to **Input Monitoring**, where it is currently absent
(`kTCCServiceListenEvent` has no synergy entry).

Confirm the tester result against a *real* shortcut before trusting it — many
keyboard testers only listen for keydown/keyup and miss synthetic modifiers,
which arrive as flag-change events.

---

## 7. Traps

**Restarting Synergy.app on macOS breaks the connection.** This already happened.
Quitting the app makes the service exit with the tray, and `synergy-core client`
does not respawn — not via `open -a Synergy`, not via
`launchctl kickstart -k gui/$(id -u)/com.symless.synergy3`, not by launching
`synergy-service -d` by hand (that yields `FATAL - existing service detected`).
The log sticks on a 2-second loop:
```
service - DEBUG2 - starting process: /Applications/Synergy.app/Contents/MacOS/synergy-security
```
Recovery required user action in the GUI, and ultimately a reboot of both
machines. **Do not restart Synergy.app to change log level.** Find another way,
or ask the user first and warn them.

**`~/Library/Preferences/Synergy/synergy.conf` on the Mac is a stale decoy.**
Dated Aug 17, inert (the Mac is a client), and it *contradicts* the real config —
it has `Backslash → golf` and `Semicolon → alpha`, the reverse of the live
server, plus transposed link topology. It is exactly the file you would open by
mistake. Consider deleting it.

**Synergy 3 keeps GUI state in `db.json` and may regenerate `synergy.conf` from
it**, silently clobbering hand-written lines and comments. The F19 line has
survived so far (verified after a 10:50 rewrite), but if the toggle stops working
right after the user touches the Synergy GUI, check this first.

**Two pre-existing bugs in `section: options`**, reported to the user, deliberately
not fixed:
- The last two lines define the **same** hotkey `Control+Alt+Slash` twice, so one
  silently overrides the other. Intent was presumably
  `switchToScreen(alpha-0ea09446) ; keystroke(Meta+j)` on one line. This is a
  separate latent bug and does **not** affect the toggle: the user confirmed the
  key under test is `Ctrl+Alt+\` (Backslash), and the server log shows the
  Backslash binding firing correctly.
- `Control+Alt+DoubleQuote` likely never matches, since `"` needs Shift on this
  layout; the real combo would be `Control+Alt+Shift+Quote`.

**AeroSpace `focus-monitor 1` / `move-workspace-to-monitor 1`** (lines ~26, 30-31)
are index-based. Indices follow physical display arrangement and drift when
displays are rearranged. Name-based targets are stable.

---

## 8. Useful commands

```bash
# --- foxtrot (server) ---
ssh NixOS                                   # passwordless, key ~/.ssh/nixos

# Reload config in place. Graceful: keeps clients connected, no restart.
# Run this after ANY change to synergy.conf.
ssh NixOS 'kill -HUP $(pgrep -f "synergy-core server")'
# Confirm: log shows "reload configuration" -> "reloaded configuration"

# X access on foxtrot needs the GDM cookie, NOT ~/.Xauthority (which does not exist):
ssh NixOS 'export DISPLAY=:0 XAUTHORITY=/run/user/1000/gdm/Xauthority; xdotool getactivewindow'

# Watch hotkeys fire (only lines that matter in a very noisy DEBUG2 log):
ssh NixOS 'grep -E "hotkey|activate actions" ~/.var/app/com.symless.synergy/.local/state/Synergy/synergy.log | tail -20'

# --- alpha (Mac) ---
aerospace reload-config --dry-run    # validates; DOES catch bad key names
aerospace reload-config              # apply
aerospace list-monitors [--focused]
```

**`xdotool` cannot trigger Synergy hotkeys.** XTEST-synthesized keys did not
produce an `activate actions` line, while real presses did. Testing the hotkey
requires the user to physically press it. Mark the log first:

```bash
ssh NixOS 'wc -l < ~/.var/app/com.symless.synergy/.local/state/Synergy/synergy.log > /tmp/synergy_mark'
# ...user presses...
ssh NixOS 'L=~/.var/app/com.symless.synergy/.local/state/Synergy/synergy.log; \
  tail -n +$(( $(cat /tmp/synergy_mark) + 1 )) $L | grep -E "hotkey|activate|entering|leaving"'
```
Beware: the log rotates at 10 MB, which invalidates a saved line number. Check
that the current line count is still **greater** than the mark before trusting
the offset.

`aerospace reload-config --dry-run` genuinely validates key names — `f99` is
rejected with `Can't parse the key in 'f99' binding` — so a clean exit is
meaningful evidence, not just a syntax check.

---

## 9. Backups left behind

| Path | Contents |
| --- | --- |
| `/tmp/aerospace.toml.bak` | aerospace.toml before any of this work |
| `/tmp/synergy.conf.bak` | synergy.conf before the F19 line |
| `/tmp/synergy_local.json.bak` | Mac `local.json` before the log-level change |

The Mac client log level was set to `DEBUG2` for diagnostics and has since been
**reverted to `INFO`**.
