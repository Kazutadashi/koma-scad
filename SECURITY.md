# Security

KomaSCAD is a command-line tool and a set of OpenSCAD models that run on
your own computer. It does not run a server, and it does not connect to the
network.

Things that are worth reporting privately:

- A preset or model file that makes `komascad.py` write files outside the
  folder it was asked to write to.
- A way for a crafted preset file to run commands on your computer.

Please report these through GitHub's
[private vulnerability reporting](https://github.com/Kazutadashi/koma-scad/security/advisories/new),
not in a public issue. We will reply as soon as we can.

Everything else, including a crash on a bad preset, is an ordinary bug: use
the [bug report form](https://github.com/Kazutadashi/koma-scad/issues/new?template=bug.yml).

Only the latest version is supported.
