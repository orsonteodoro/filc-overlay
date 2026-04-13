# filc-overlay

Gentoo overlay for **Fil-C** — Filip Pizlo’s memory-safe C/C++ compiler.

This overlay provides ebuilds and profiles to integrate Fil-C into Gentoo systems.

## Important Notes

- Fil-C is still experimental. Expect rough edges.
- Fil-C introduces its own ABI. Mixing normal gcc/clang binaries with Fil-C compiled code is **not guaranteed** to work and may cause crashes.
- The recommended workflow is to rebuild critical parts of the system with Fil-C.

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

This overlay will include recommended defaults and per-package overrides for the most common packages that rely on GNU extensions.

### Workflow After filc-bootstrap LC Phase

1. Emerge the filc-gentoo overlay.
2. Set the Fil-C toolchain.
3. emerge -e @system
4. emerge -ve @world (or more selective rebuilds).

Toolchain updates are handled by re-running the appropriate parts of filc-bootstrap first, then triggering a new world rebuild here.

## Installation

Add the overlay:

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

### Available Profiles
Fil-C provides versioned profiles under the filc:17.1 namespace.

### Profile Levels
* unstrict — Maximum compatibility. Allows Rust, Go, and other languages. Best for daily use.
* strict — C/C++ focused. Masks Rust and Go. Stronger mitigation while remaining usable.
* hardcore — Extreme security mode. Aggressive masking of non-C/C++ languages. Adventurous/experimental.
Warning: Hardcore mode may require manual workarounds (e.g. Paludis or custom setup) because it restricts many packages. Python and Perl are kept only where essential (Portage, kernel build, crypto, browsers).

### Main Profiles
#### merged-usr (most users):
* filc:17.1/merged-usr/cxx20/glibc/unstrict ← Default / Recommended
* filc:17.1/merged-usr/cxx20/glibc/strict
* filc:17.1/merged-usr/cxx20/glibc/hardcore
* filc:17.1/merged-usr/cxx20/musl/unstrict
* filc:17.1/merged-usr/cxx20/musl/strict
* filc:17.1/merged-usr/cxx20/musl/hardcore

#### split-usr:
* filc:17.1/split-usr/cxx20/glibc/unstrict
* filc:17.1/split-usr/cxx20/glibc/strict
* filc:17.1/split-usr/cxx20/glibc/hardcore
* filc:17.1/split-usr/cxx20/musl/unstrict
* filc:17.1/split-usr/cxx20/musl/strict
* filc:17.1/split-usr/cxx20/musl/hardcore


### How to Select a Profile

```bash

# Recommended starting point
eselect profile set filc:17.1/merged-usr/cxx20/glibc/unstrict

# Strict version
eselect profile set filc:17.1/merged-usr/cxx20/glibc/strict

# Extreme hardcore mode (use with caution)
eselect profile set filc:17.1/merged-usr/cxx20/glibc/hardcore

# List all profiles
eselect profile list


```

### Installing Fil-C

```bash

emerge -av sys-devel/filc

```

After installation, activate a version:

```bash

eselect filc set live     # for latest development
# or
eselect filc set 0.678    # for tagged release

```

### Basic Usage

```bash

filcc hello.c -o hello
fil++ hello.cpp -o hello_cpp

```

### Rebuilding the System

After activating Fil-C, you can rebuild parts of the system:

```bash

emerge -e @system
emerge -ve @world

```

Note: Full system rebuilds with Fil-C can take a very long time and may require significant RAM and disk space.

### Hardcore Mode Notes
The hardcore profile is intended for users who want maximum mitigation. It aggressively masks non-C/C++ languages.
Python and Perl are kept only where absolutely necessary (Portage, kernel compilation, crypto libraries, browsers).
You may need to use alternative tools or package managers (e.g. Paludis) for full hardcore usage.

### Current Status

* sys-devel/filc — Available as live (9999) and tagged (0.678) versions
* app-eselect/eselect-filc — Provides version switching
* Profiles — Ready for merged-usr and split-usr with glibc (musl secondary)

### Future Plans

* Better integration with filc-bootstrap
* Improved yolo-glibc handling
* Catalyst-style stage generation
* Enhanced hardcore mode tooling

### Feedback & Contributions

Feel free to open issues or pull requests on GitHub.

### Related Repository

filc-bootstrap — distro-agnostic Pre-LC + LC phases.

---

- Status: Planning / initial ebuilds
- Main goal: Make Fil-C a first-class, maintainable experience on Gentoo.
