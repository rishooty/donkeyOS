FROM registry.fedoraproject.org/fedora-minimal:latest

# Set the correct labels
LABEL ostree.bootable="true"
LABEL ostree.final-diffid="sha256:$(ostree --repo=/ostree/repo rev-parse HEAD)"

# Install essential packages
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

# Set up OSTree
RUN ostree admin init-fs / && \
    ostree config --repo=/ostree/repo set sysroot.readonly true

# Create an OSTree commit
RUN ostree commit -b donkeyos/base/x86_64 \
    --tree=dir=/ \
    --skip-if-unchanged

# Encapsulate the OSTree commit
RUN ostree container encapsulate \
    --repo=/ostree/repo \
    donkeyos/base/x86_64 \
    containers-storage:localhost/donkeyos:latest

CMD ["ostree", "container", "commit"]
