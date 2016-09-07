echo "+---------------------------------------------------------------------------------------------+";
echo "|          MongoDB install script with PHP7 & nginx [Laravel Homestead]                       |"
echo "|               By Aleksandar Bjelosevic, abjelosevic88@gmail.com                             |"
echo "+---------------------------------------------------------------------------------------------+";

echo ""
echo ""
echo "+                    Importing the public key used by the package management system           +";
echo ""
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                            Creating a list file for MongoDB                                 + ";
echo ""
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                              Updating the packages list                                     +";
echo ""
sudo apt-get update;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                           Install the latest version of mongoDB                             +";
echo ""
sudo apt-get install -y mongodb-org;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                              Fixing the pecl errors list                                    +";
echo ""
sudo sed -i -e 's/-C -n -q/-C -q/g' `which pecl`;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                              Installing OpenSSl Libraries                                   +";
echo ""
sudo apt-get install -y autoconf g++ make openssl libssl-dev libcurl4-openssl-dev;
sudo apt-get install -y libcurl4-openssl-dev pkg-config;
sudo apt-get install -y libsasl2-dev;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                             Installing PHP7 mongoDB extension                               +";
echo ""
sudo pecl install mongodb;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                        Adding the extension to your php.ini file                            +";
echo ""
sudo echo  "extension = mongodb.so" >> /etc/php/7.0/cli/php.ini;
sudo echo  "extension = mongodb.so" >> /etc/php/7.0/fpm/php.ini;
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                                Add mongodb.service file                                     +"
echo ""
cat >/etc/systemd/system/mongodb.service <<EOL
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl start mongodb
sudo systemctl status mongodb
sudo systemctl enable mongodb
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                                Restarting The nginx server                                  +";
echo ""
sudo service nginx restart && sudo service php7.0-fpm restart
echo "+=============================================================================================+";

echo ""
echo ""
echo "+                 Creating basic admin user for MongoDB with Laravel Default credentials      +";
echo ""
mongo admin --eval "db.createUser({ user: \"homestead\", pwd: \"secret\", roles: [ { role: \"userAdminAnyDatabase\", db: \"admin\" } ]})"
echo "                                          Done!                                                "

echo ""
echo ""
echo "+---------------------------------------------------------------------------------------------+";
echo "|              For any questions you can contact me at: abjelosevic88@gmail.com               |"
echo "+---------------------------------------------------------------------------------------------+";
