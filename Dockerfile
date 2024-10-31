FROM registry.fedoraproject.org/fedora-minimal:latest

# Set the correct ostree bootable label
LABEL ostree.bootable="true"

# Install essential packages using microdnf
RUN microdnf install -y \
    rpm-ostree \
    ostree \
    kernel \
    systemd \
    dracut \
    sudo \
    grub2-efi-x64 \
    grub2-pc \
    efibootmgr \
    && microdnf clean all

# Configure the system
RUN systemctl mask tmp.mount \
    && mkdir -p /etc/sudoers.d \
    && echo "root ALL=(ALL) NOPASSWD: /usr/bin/rpm-ostree" > /etc/sudoers.d/rpm-ostree \
    && chmod 0440 /etc/sudoers.d/rpm-ostree

# Set up the root password
RUN echo "root:password123" | chpasswd

# Create necessary directories for OSTree
RUN mkdir -p /sysroot \
    && mkdir -p /var \
    && mkdir -p /usr/etc \
    && mkdir -p /etc/ostree/remotes.d

# Configure OSTree
RUN ostree admin init-fs /sysroot \
    && ostree config --repo=/sysroot/ostree/repo set sysroot.readonly true

# Commit the container
CMD ["ostree", "container", "commit"]
