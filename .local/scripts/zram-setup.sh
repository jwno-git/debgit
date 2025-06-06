#!/bin/bash

# Manual zram configuration script
# More efficient and configurable than zram-tools

set -e

echo "=== Setting up zram swap ==="

# Install required packages
sudo apt install -y util-linux

# Load zram module
sudo modprobe zram

# Create systemd service for zram
sudo tee /etc/systemd/system/zram-swap.service > /dev/null << EOF
[Unit]
Description=Configures zram swap device
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/zram-start.sh
ExecStop=/usr/local/bin/zram-stop.sh
TimeoutSec=30

[Install]
WantedBy=multi-user.target
EOF

# Create start script
sudo tee /usr/local/bin/zram-start.sh > /dev/null << EOF
#!/bin/bash
set -e

# Check if zram0 already exists
if [ -b /dev/zram0 ]; then
    echo "zram0 already exists, skipping setup"
    exit 0
fi

# Load zram module with number of devices
modprobe zram num_devices=1

# Set compression algorithm
echo zstd > /sys/block/zram0/comp_algorithm

# Set device size
echo 8G > /sys/block/zram0/disksize

# Format as swap
sudo mkswap /dev/zram0

# Enable swap with priority
sudo swapon -p 100 /dev/zram0

echo "zram swap enabled: 8G with zstd compression"
EOF

# Create stop script
sudo tee /usr/local/bin/zram-stop.sh > /dev/null << EOF
#!/bin/bash
set -e

# Disable swap if active
if grep -q "/dev/zram0" /proc/swaps; then
    sudo swapoff /dev/zram0
    echo "zram swap disabled"
fi

# Reset device if it exists
if [ -b /dev/zram0 ]; then
    echo 1 > /sys/block/zram0/reset
fi

# Unload module
rmmod zram 2>/dev/null || true
EOF

# Make scripts executable
sudo chmod +x /usr/local/bin/zram-start.sh
sudo chmod +x /usr/local/bin/zram-stop.sh

# Create zram status check script
sudo tee /usr/local/bin/zram-status.sh > /dev/null << 'EOF'
#!/bin/bash

echo "=== zram Status ==="
if [ -b /dev/zram0 ]; then
    echo "zram device: /dev/zram0"
    echo "Size: $(cat /sys/block/zram0/disksize | numfmt --to=iec)"
    echo "Algorithm: $(cat /sys/block/zram0/comp_algorithm | grep -o '\[.*\]' | tr -d '[]')"
    echo "Used: $(cat /sys/block/zram0/mem_used_total | numfmt --to=iec)"
    echo "Compression ratio: $(cat /sys/block/zram0/compr_data_size):$(cat /sys/block/zram0/orig_data_size)"
    echo ""
    echo "=== Swap Status ==="
    swapon --show
else
    echo "zram device not found"
fi
EOF

sudo chmod +x /usr/local/bin/zram-status.sh

# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable zram-swap.service

# Start the service now
sudo systemctl start zram-swap.service

echo ""
echo "=== zram setup complete! ==="
echo ""
echo "Configuration:"
echo "  Size: 8G"
echo "  Algorithm: zstd" 
echo "  Priority: 100"
echo ""
echo "Management commands:"
echo "  sudo systemctl start zram-swap    # Enable zram"
echo "  sudo systemctl stop zram-swap     # Disable zram"
echo "  sudo systemctl status zram-swap   # Check status"
echo "  sudo zram-status.sh               # Detailed status"
echo ""
echo "To modify configuration, edit /usr/local/bin/zram-start.sh"

# Show current status
/usr/local/bin/zram-status.sh
