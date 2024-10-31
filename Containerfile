FROM quay.io/fedora/fedora-coreos:stable

# Install additional packages if needed
RUN rpm-ostree install -y \
    cage \
    && rpm-ostree cleanup -m

# Add any custom configurations or files
# COPY your-config-file /etc/your-config-file

# Set the entrypoint
ENTRYPOINT ["/usr/sbin/init"]
