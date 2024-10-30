FROM registry.fedoraproject.org/fedora-minimal:latest

# Install essential packages using microdnf
RUN microdnf install -y \
    rpm-ostree \
    ostree \
    kernel \
    systemd \
    dracut \
    sudo \
    && microdnf clean all

# Configure the system
RUN systemctl mask tmp.mount \
    && mkdir -p /etc/sudoers.d \
    && echo "root ALL=(ALL) NOPASSWD: /usr/bin/rpm-ostree" > /etc/sudoers.d/rpm-ostree \
    && chmod 0440 /etc/sudoers.d/rpm-ostree

# Set up the root password
RUN echo "root:password123" | chpasswd

# Commit the container
CMD ["ostree", "container", "commit"]
