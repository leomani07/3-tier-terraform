pipeline {
    agent { label 'ubuntu' }   // Jenkins agent on EC2 or controller

    environment {
        WEB_EC2_IP   = "43.205.124.213"   // public/private IP of Web EC2
        APP_EC2_IP   = "10.0.2.214"   // public/private IP of App EC2
        RDS_ENDPOINT = "mydb.cliumscw44qs.ap-south-1.rds.amazonaws.com:3306"
        DB_USER      = "admin"
        DB_PASS      = "Function!"   // put in Jenkins credentials ideally
        DB_NAME      = "LoginDB"
        APP_REPO     = "https://github.com/leomani07/3-tier-terraform.git"
        APP_DIR      = "/var/www/html"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Setup Web Tier') {
            steps {
                sh '''
                echo "🌐 Configuring Web EC2..."
                ssh -o StrictHostKeyChecking=no ubuntu@${WEB_EC2_IP} <<'EOF'
                  sudo apt update -y
                  sudo apt install -y apache2
                  sudo systemctl enable apache2
                  sudo systemctl start apache2

                  # Configure Apache to reverse proxy to App EC2
                  sudo apt install -y libapache2-mod-proxy-html libxml2-dev
                  sudo a2enmod proxy proxy_http
                  echo "<VirtualHost *:80>
                      ProxyPreserveHost On
                      ProxyPass / http://${APP_EC2_IP}/
                      ProxyPassReverse / http://${APP_EC2_IP}/
                  </VirtualHost>" | sudo tee /etc/apache2/sites-available/000-default.conf

                  sudo systemctl restart apache2
                EOF
                '''
            }
        }

        stage('Setup App Tier') {
            steps {
                sh '''
                echo "⚙️ Configuring App EC2..."
                ssh -o StrictHostKeyChecking=no ubuntu@${APP_EC2_IP} <<'EOF'
                  sudo apt update -y
                  sudo apt install -y apache2 php libapache2-mod-php php-mysql git mysql-client
                  sudo systemctl enable apache2
                  sudo systemctl start apache2

                  # Deploy application code
                  sudo rm -rf ${APP_DIR}/*
                  sudo git clone ${APP_REPO} ${APP_DIR}
                  sudo chown -R www-data:www-data ${APP_DIR}

                  # Inject DB creds into config.php
                  cat > ${APP_DIR}/config.php <<CONFIG
                  <?php
                  \$host     = "${RDS_ENDPOINT}";
                  \$username = "${DB_USER}";
                  \$password = "${DB_PASS}";
                  \$database = "${DB_NAME}";
                  \$conn = new mysqli(\$host, \$username, \$password, \$database);
                  if (\$conn->connect_error) {
                      die("Connection failed: " . \$conn->connect_error);
                  }
                  ?>
                  CONFIG
                EOF
                '''
            }
        }

        stage('Init Database (RDS)') {
            steps {
                sh '''
                echo "🛢️ Setting up schema in RDS..."
                mysql -h ${RDS_ENDPOINT} -u${DB_USER} -p${DB_PASS} <<EOF
                CREATE DATABASE IF NOT EXISTS ${DB_NAME};
                USE ${DB_NAME};
                CREATE TABLE IF NOT EXISTS users (
                  id INT AUTO_INCREMENT PRIMARY KEY,
                  username VARCHAR(50) NOT NULL UNIQUE,
                  password VARCHAR(255) NOT NULL
                );
EOF
                '''
            }
        }

        stage('Smoke Test from Web Tier') {
            steps {
                sh '''
                echo "🔍 Running smoke test..."
                curl -s http://${WEB_EC2_IP} | grep "Login & Register" || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "✅ 3-Tier Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed! Check logs."
        }
    }
}

