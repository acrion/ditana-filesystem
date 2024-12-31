# Ditana Filesystem

This package replaces the standard filesystem package from Arch Linux, providing Ditana-specific customizations and core system files for Ditana GNU/Linux.

## Description

Ditana Filesystem is a crucial core package that forms the foundation of the Ditana GNU/Linux distribution. It includes essential system files, configurations, and Ditana-specific adaptations.

## Features

- Replaces the standard Arch Linux filesystem package
- Includes Ditana-specific logos and branding
- Provides core system configuration files
- Implements security enhancements

## Key Components

1. **Wheel Group Configuration**:
   - File: `99-wheel-group`
   - Location: `/etc/sudoers.d/`
   - Purpose: Configures sudo access for the wheel group

2. **System Identification**:
   - File: `issue`
   - Purpose: Displays Ditana GNU/Linux branding on login prompts

3. **Ditana Branding**:
   - Replaces Arch Linux logos with Ditana-specific logos

4. **Other System Files**:
   - Modified `os-release` and `profile` files to reflect Ditana GNU/Linux specifics

## DNS Configuration

Unlike the upstream Arch Linux filesystem package, Ditana deliberately avoids creating or linking an `/etc/resolv.conf` file. Instead, Ditana uses systemd-resolved for DNS resolution, configured through the file `/etc/systemd/resolved.conf.d/90-ditana.conf`. This file is installed by the [ditana-network](https://github.com/acrion/ditana-network) package.

### Rationale for this approach:

1. **Centralized DNS Management**: systemd-resolved is configured to manage DNS resolution exclusively through its internal mechanisms.
2. **Conflict Prevention**: This approach eliminates potential conflicts and inconsistencies that can arise from multiple DNS configurations.
3. **Simplified Configuration**: By centralizing DNS configuration under systemd-resolved, we avoid the redundancy of maintaining multiple DNS configuration points.

This design decision ensures a more consistent and manageable network configuration across Ditana systems, reducing the potential for DNS-related issues and simplifying system administration.

For more details on Ditana's network configuration, including DNS settings, please refer to the [ditana-network repository](https://github.com/acrion/ditana-network).

## Installation and Package Management

This package is a core component of Ditana GNU/Linux and should not be manually installed or replaced on a Ditana system. To ensure proper functioning and prevent conflicts with the standard Arch Linux filesystem package, the Ditana installer makes the following modifications:

1. **Ignoring the standard filesystem package**:
   The Ditana installer adds the following line to `/etc/pacman.conf`:
   ```
   IgnorePkg   = filesystem
   ```
   This prevents the standard Arch Linux filesystem package from being updated or replaced, ensuring that the Ditana-specific version remains in place. This step is crucial because pacman gives priority to packages from repositories listed earlier in the configuration.

2. **Ditana Repository Configuration**:
   The Ditana repository is added at the end of the `/etc/pacman.conf` file. Despite this positioning, the `IgnorePkg` directive ensures that the Ditana filesystem package is used instead of the standard Arch package. Without this directive, the earlier-listed Arch repositories would take precedence, potentially overwriting Ditana-specific modifications.

These configurations allow the Ditana filesystem package to effectively replace the standard Arch Linux filesystem package while maintaining system integrity and Ditana-specific customizations.

## Upstream Source

This package is based on the Arch Linux filesystem package. The upstream repository can be found at:
https://gitlab.archlinux.org/archlinux/packaging/packages/filesystem.git

Regular merges are performed to incorporate upstream changes while maintaining Ditana-specific customizations.

## Support

For issues, feature requests, or contributions related to Ditana Filesystem, please use the official Ditana GNU/Linux support channels or submit a pull request to the Ditana repository.

---

Ditana Filesystem is a fundamental component of the Ditana GNU/Linux project, providing the core file structure and configurations that define the Ditana experience.
