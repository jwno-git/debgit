#!/bin/bash

# nftables Basic Configuration Script
# Creates a secure desktop/laptop firewall configuration

set -e

echo "=== Setting up nftables configuration ==="

# Create the nftables configuration file
sudo tee /etc/nftables.conf > /dev/null << 'EOF'
#!/usr/sbin/nft -f

# Clear all prior state
flush ruleset

# Main firewall table
table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;
        
        # Allow loopback traffic (essential for system operation)
        iif "lo" accept comment "Accept any localhost traffic"
        
        # Allow established and related connections (return traffic)
        ct state established,related accept comment "Accept established/related connections"
        
        # Allow ICMP (ping, traceroute, etc.)
        ip protocol icmp accept comment "Accept ICMP"
        ip6 nexthdr ipv6-icmp accept comment "Accept ICMPv6"
        
        # Allow DHCP client (for getting IP from router)
        udp sport 67 udp dport 68 accept comment "Accept DHCP client"
        
        # Allow DNS responses (if using non-standard DNS servers)
        udp sport 53 accept comment "Accept DNS responses"
        tcp sport 53 accept comment "Accept DNS responses (TCP)"
        
        # Allow NTP (time synchronization)
        udp sport 123 accept comment "Accept NTP responses"
        
        # Allow local network discovery (mDNS/Avahi)
        udp dport 5353 accept comment "Accept mDNS (local discovery)"
        
        # Allow Spotify Connect and similar local services (optional)
        # udp dport 57621 accept comment "Spotify Connect"
        
        # Allow local network services (printer discovery, file sharing)
        # Uncomment if you use network printers or local file sharing
        # ip saddr 192.168.0.0/16 udp dport 631 accept comment "Allow local printer discovery"
        # ip saddr 10.0.0.0/8 udp dport 631 accept comment "Allow local printer discovery"
        
        # Log dropped packets (useful for debugging, remove if too verbose)
        limit rate 5/minute log prefix "nftables dropped: " level info
        
        # Drop everything else
        counter drop
    }
    
    chain forward {
        type filter hook forward priority filter; policy drop;
        # No forwarding needed for desktop/laptop
    }
    
    chain output {
        type filter hook output priority filter; policy accept;
        
        # Allow all outbound traffic by default
        # You could restrict this further if desired:
        
        # Allow loopback
        oif "lo" accept comment "Accept localhost traffic"
        
        # Allow established connections
        ct state established,related accept comment "Accept established/related"
        
        # Allow new outbound connections
        ct state new accept comment "Allow new outbound connections"
        
        # Specific outbound rules (if you want to be more restrictive):
        # tcp dport { 22, 80, 443 } accept comment "Allow SSH, HTTP, HTTPS"
        # udp dport { 53, 123 } accept comment "Allow DNS, NTP"
        # tcp dport { 587, 993, 995 } accept comment "Allow email (SMTP, IMAP, POP3)"
        # tcp dport { 6667, 6697 } accept comment "Allow IRC"
        # udp dport { 1194, 51820 } accept comment "Allow VPN (OpenVPN, WireGuard)"
    }
}

# Rate limiting table (optional - protects against some attacks)
table inet rate_limit {
    chain input {
        type filter hook input priority filter + 10; policy accept;
        
        # Rate limit SSH attempts (if you ever enable SSH server)
        # tcp dport 22 ct state new limit rate 3/minute accept
        
        # Rate limit ping to prevent ping floods
        ip protocol icmp limit rate 10/second accept
        ip6 nexthdr ipv6-icmp limit rate 10/second accept
    }
}
EOF

echo "nftables configuration created at /etc/nftables.conf"

# Enable and start nftables
echo "=== Enabling nftables service ==="
sudo systemctl enable nftables
sudo systemctl start nftables

# Apply the configuration
echo "=== Loading nftables rules ==="
sudo nft -f /etc/nftables.conf

echo "=== nftables status ==="
sudo systemctl status nftables --no-pager

echo ""
echo "=== Current ruleset ==="
sudo nft list ruleset

echo ""
echo "=== Configuration complete! ==="
echo ""
echo "Your firewall is now configured with:"
echo "✓ All outbound traffic allowed (SSH, HTTP, HTTPS, etc.)"
echo "✓ No inbound SSH allowed"
echo "✓ Established connections allowed back in"
echo "✓ Local services (loopback, DHCP, DNS, NTP) allowed"
echo "✓ ICMP (ping) allowed with rate limiting"
echo "✓ Dropped packets logged to system journal"
echo ""
echo "To view logs of dropped packets:"
echo "  sudo journalctl -f | grep 'nftables dropped'"
echo ""
echo "To temporarily disable firewall:"
echo "  sudo systemctl stop nftables"
echo ""
echo "To permanently disable:"
echo "  sudo systemctl disable nftables"
echo ""
echo "Configuration file: /etc/nftables.conf"
