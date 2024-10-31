FROM registry.fedoraproject.org/fedora-minimal:latest

# Set the correct labels
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

# Create and configure treefile
RUN mkdir -p /usr/share/rpm-ostree && \
    cat > /usr/share/rpm-ostree/treefile.yaml << 'EOF'
ref: donkeyos/base/x86_64
repos:
- fedora-41
packages:
- rpm-ostree
- ostree
- kernel
- systemd
- dracut
- sudo
- grub2-efi-x64
- grub2-pc
- efibootmgr
automatic_version_prefix: "1.0"
boot_location: new
documentation: false
tmp_is_dir: true
EOF

# Set up OSTree repository
RUN mkdir -p /ostree/repo && \
    ostree --repo=/ostree/repo init --mode=bare-user

# Compose tree
RUN rpm-ostree compose tree \
    --repo=/ostree/repo \
    --unified-core \
    /usr/share/rpm-ostree/treefile.yaml

# Configure the system
RUN systemctl mask tmp.mount \
    && mkdir -p /etc/sudoers.d \
    && echo "root ALL=(ALL) NOPASSWD: /usr/bin/rpm-ostree" > /etc/sudoers.d/rpm-ostree \
    && chmod 0440 /etc/sudoers.d/rpm-ostree

# Set up the root password
RUN echo "root:password123" | chpasswd

CMD ["rpm-ostree", "container", "commit"]
