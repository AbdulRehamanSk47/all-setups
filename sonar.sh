#!/bin/bash
# --------------------------------------------
# SonarQube 8.9.6 (LTS) Setup Script on Amazon Linux
# --------------------------------------------

# 1️⃣ Update and install dependencies
sudo yum update -y
sudo amazon-linux-extras install java-openjdk17 -y
sudo yum install unzip wget git -y

# 2️⃣ Create SonarQube directory
cd /opt/
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip
sudo unzip sonarqube-8.9.6.50800.zip
sudo mv sonarqube-8.9.6.50800 sonarqube

# 3️⃣ Create sonar user and assign permissions
sudo useradd sonar
sudo chown -R sonar:sonar /opt/sonarqube
sudo chmod -R 755 /opt/sonarqube

# 4️⃣ Configure system limits (recommended for SonarQube)
echo "sonar   -   nofile   65536" | sudo tee -a /etc/security/limits.conf
echo "sonar   -   nproc    4096" | sudo tee -a /etc/security/limits.conf

# 5️⃣ Create systemd service file for SonarQube
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=on-failure
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

# 6️⃣ Reload systemd daemon and enable service
sudo systemctl daemon-reload
sudo systemctl enable sonarqube

# 7️⃣ Start SonarQube
sudo systemctl start sonarqube

# 8️⃣ Check SonarQube status
sudo systemctl status sonarqube -l

# 9️⃣ Firewall / Security Group configuration
echo "⚙️ Make sure port 9000 is open in your AWS Security Group!"
echo "SonarQube is starting... It may take 1-2 minutes."

#  🔟 Access Info
echo "-------------------------------------------------------"
echo "✅ SonarQube installation completed!"
echo "Access SonarQube at: http://<EC2-PUBLIC-IP>:9000"
echo "Default Login: admin / admin"
echo "-------------------------------------------------------"
