# filc-gentoo

**Gentoo overlay for Fil-C** — memory-safe C/C++ on Gentoo Linux.

This repository provides Gentoo ebuilds, profiles, and integration to complete the Fil-C bootstrap after the `filc-bootstrap` LC phase.

### Purpose

- Supply proper ebuilds for `sys-devel/fil-c`, `sys-libs/user-glibc-filc`, and Fil-C variants of core packages (bash, python, perl, etc.).
- Provide a toolchain profile / eselect module so `CC=filcc` and `CXX=fil++` are used system-wide.
- Handle the **Post-LC** phase: `emerge -e @system` followed by `emerge -e @world` (or staged rebuilds) under the Fil-C toolchain.
- Manage patches and `USE` flags for packages that need adjustments when built with Fil-C.

### Default Language Standards (Fil-C)

Fil-C (based on Clang 20.1.8) uses the following defaults:

- **C**: `-std=c17` (pure ISO C17)
- **C++**: `-std=c++20` (pure ISO C++20)

**GNU extensions are disabled by default.**

In `make.conf` or package-specific ebuilds you will commonly need to add:

```bash
CFLAGS="${CFLAGS} -std=gnu17"
CXXFLAGS="${CXXFLAGS} -std=gnu++20"
```

This overlay will include recommended defaults and per-package overrides for the most common packages that rely on GNU extensions.Workflow After filc-bootstrap LC PhaseEmerge the filc-gentoo overlay.
Set the Fil-C toolchain.
emerge -e @system
emerge -ve @world (or more selective rebuilds).

Toolchain updates are handled by re-running the appropriate parts of filc-bootstrap first, then triggering a new world rebuild here.

## Installation

```bash
mkdir -p /etc/portage/repos.conf
cat > /etc/portage/repos.conf/filc.conf <<EOF
[filc]
location = /var/db/repos/filc
sync-type = git
sync-uri = https://github.com/OrsonTeodoro/filc-overlay.git
auto-sync = yes
EOF

emerge --sync filc
```

### Related Repository

filc-bootstrap — distro-agnostic Pre-LC + LC phases.

---

- Status: Planning / initial ebuilds
- Main goal: Make Fil-C a first-class, maintainable experience on Gentoo.



