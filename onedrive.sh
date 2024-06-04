echo "follow the instructions on, call the remote server myonedrive"
rclone config
# mount the drive called "myonedrive" on the folder ~/onedrive
mkdir ~/onedrive

sudo cp ~/repos/laptop-setup/assets/rcloneonedrive.service /tmp/
# replace CURRENT_USER with the current user
sudo sed -i "s/CURRENT_USER/$USER/g" /tmp/rcloneonedrive.service

# copy rcloneonedrive.service to /etc/systemd/system/
sudo cp /tmp/rcloneonedrive.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable rcloneonedrive.service
sudo systemctl start rcloneonedrive.service
sudo systemctl status rcloneonedrive.service

