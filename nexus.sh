# Update packages
sudo yum update -y

# Install wget and Java 17
sudo yum install -y wget
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto

# Create application directory
sudo mkdir -p /app && cd /app

# Download Nexus 3.84.1-01
sudo wget https://download.sonatype.com/nexus/3/nexus-3.84.1-01-linux-x86_64.tar.gz -O nexus.tar.gz

# Extract and rename
sudo tar -xvf nexus.tar.gz
sudo mv nexus-3.84.1-01 nexus

# Create nexus user
sudo adduser nexus

# Create sonatype-work directory
sudo mkdir -p /app/sonatype-work

# Set ownership
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

# Configure run_as_user
echo 'run_as_user="nexus"' | sudo tee /app/nexus/bin/nexus.rc

# Create systemd service file
sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable and start Nexus
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus
