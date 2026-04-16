# filc-overlay

Gentoo overlay for **Fil-C** — Filip Pizlo’s memory-safe C/C++ compiler.

This overlay provides ebuilds and profiles to integrate Fil-C into Gentoo.

## Current Approach (Option A - Initial Adoption)

For the first version, we are using the **existing Fil-C bootstrap scripts** (`build_all_fast_glibc.sh`, etc.) directly inside the ebuilds.

**Why this approach?**
- Allows quick testing of Fil-C viability on Gentoo.
- Reuses the complex build logic already developed in `filc-bootstrap`.
- Avoids immediate divergence from upstream Fil-C.

**Limitations of this approach:**
- The build process is not fully native Gentoo style.
- Install paths are based on the bootstrap's pizlix layout.
- We are effectively "pizlix-ing" Gentoo for now.  Pizlix is the Linux distro with the Fil-C compiler.

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

### Available Profiles
Fil-C provides versioned profiles under the filc:17.1 namespace.
### Main Profiles (glibc primary):
* filc:17.1/merged-usr/cxx20/glibc/unstrict ← Default / Recommended
* filc:17.1/merged-usr/cxx20/glibc/strict
* filc:17.1/merged-usr/cxx20/glibc/hardcore
* filc:17.1/merged-usr/cxx20/musl/unstrict
* filc:17.1/merged-usr/cxx20/musl/strict
* filc:17.1/merged-usr/cxx20/musl/hardcore

Split-usr variants are also available (replace merged-usr with split-usr).
### Profile Levels
* unstrict — Maximum compatibility. Allows Rust, Go, Python, Perl, etc.
* strict — C/C++ focused. Masks Rust and Go for stronger mitigation.
* hardcore — Extreme security mode. Aggressive masking of non-C/C++ languages. Experimental and adventurous. May require alternative tools or package managers (e.g. Paludis).

Hardening flags are enabled across all profiles.How to Select a Profile
```bash

# Recommended default
eselect profile set filc:17.1/merged-usr/cxx20/glibc/unstrict

# List all profiles
eselect profile list
```

Installing Fil-C
```bash

emerge -av sys-devel/filc
```

After installation, set the compiler:
```bash

export CC=/usr/lib/fil-c/bin/filcc
export CXX=/usr/lib/fil-c/bin/fil++
```

Then rebuild:
```bash

emerge -e @system
emerge -ve @world
```

### Overlay Plan & Future Transition
#### Phase 1 (Current - Initial Adoption)
* Use existing Fil-C bootstrap scripts inside the ebuilds.
* Mono-slot installation for simplicity.
* Focus on testing viability on Gentoo.
* Provide basic profiles (unstrict / strict / hardcore).

#### Phase 2 (Transition to Native Integration)
* Gradually refactor the build system toward a clean CMake/Meson-based ebuild.
* Improve multi-slot support and eselect integration.
* Make the packaging more compliant with Gentoo and other distro guidelines.
* Reduce reliance on hardcoded bootstrap paths.
* Better support for parallel versions and clean upgrades.

The goal is to evolve from "pizlix-ing Gentoo" to a proper, maintainable Gentoo-native integration.

### Current Status
* sys-devel/filc — Available as 9999 (live) and 0.678 (tagged)
* Profiles — Ready with glibc primary, musl secondary
* Approach — Bootstrap-based for rapid testing

### Future Plans
* Cleaner build system (CMake/Meson)
* Better eselect or gcc-config-like muxer
* Catalyst-style stage generation
* Improved hardcore mode tooling
* Better documentation and adoption path for other distros

### Feedback & Contributions

This is an early-stage overlay. Feedback and contributions are welcome.

* **Related Project**: [filc-bootstrap](https://github.com/orsonteodoro/filc-bootstrap)


