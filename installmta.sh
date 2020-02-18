#!/bin/bash

sudo su -
apt-get install -y git
cd /opt
git clone https://github.com/Mailtrain-org/mailtrain.git
cd mailtrain
git checkout development
bash setup/install-ubuntu1804-https.sh mt.$1 box.$1 list.$1 admin@$1
systemctl start mailtrain
systemctl enable mailtrain
cd /opt/mailtrain/zone-mta
git clone https://github.com/zone-eu/zmta-webadmin.git
cd zmta-webadmin
sed -i -e 's/host = \"127.0.0.1\"/host = \"0.0.0.0\"/g' config/default.toml
npm install --production
sed  -i '132s/.*/  enabled: true/' /opt/mailtrain/server/config/default.yaml
sudo hostnamectl set-hostname mt.$1
sed -i '8s/.*/138.197.58.191 mt.$1/' /etc/hosts
sed -i '15s/.*/preserve_hostname: true/' /etc/cloud/cloud.cfg
(crontab -l; echo "0 * * * * systemctl reboot -i" ) | crontab -
(crontab -l; echo "5 * * * * npm start --prefix  /opt/mailtrain/zone-mta/zmta-webadmin" ) | crontab -
echo update mailtrain.send_configurations set mailer_settings = '{"maxConnections":5,"throttling":0,"logTransactions":false,"maxMessages":100,"zoneMtaType":3,"dkimDomain":"v.$1","dkimSelector":"key", "dkimPrivateKey":"-----BEGIN RSA PRIVATE KEY-----\\nMIIEogIBAAKCAQEAghJmbwUGdTohcrwGezfQbAc8wHnubKrOVgVcfnXEo2DQn/Kp\\nkhdoHAhbM+odE7Q4c53BapxZnN/xqQ/RA0tNJLeecDmpBOVo0ZN1JarFuVhZM0hX\\neW2E1XmArVzFEMfVvYG8HO7iDA7H9IzGbtVnQ97SdMVaMU1okfnS5ZepBMUnElpp\\nYKCid6MLzEnVJdzYRUGbe+Wy8GlvOd6UgTgGx0tYI8OT3HG3DBnjxllREEqOYMOr\\nQzHawG2Q6U2z/H3LRmQqGL1W3+3ly5fAhPD3ExMnelc7Ll61GHb87edC1v6NSwp8\\nYcU0bpiZwXuRuz1Vq3s6DUnbep2DPp65F86grQIDAQABAoIBAGDFO7xhKrrQcs4f\\noVrO3ZthjwtMK9xg/330Iypah99dShmVuh7clzIz7VakWNmt/UnXFm0wwWL7IZm8\\nEK64uT4V9iRcYako3GD/qepKMSyB1GtY6OuIVYlVCizwlhSz+AszmDaWa0q5PH5u\\ntbsDvf46qq0BnuaLRr9D9Gmn+bF3xLvXpRbmG9stKq76vzN/0ArV56EIk4ybC8U5\\nEHJ2jOe2ghOrxpdZRzlYCt/x7wBgkA5evQQir2hXUKi2sdBT+qtIELyC5o04fL0s\\n19mydk4n61/F/CKXlRIhavxYSrhlzoxhTwRQ1jKhmTAvqm/SwnnIPmABoFS9hEoF\\nJds8fIECgYEAvJxL8PKl3z+R/c6GzSXRwH6yL3VhwLKIAsiXMd0nuw6TREYYzqRA\\n4inoEpbdHqpZ0xwyi7J5MAchS1+le6fBq0ruDcBWf5e+9J9Pvpb1rsJe1zhIBls1\\no2+jqGPr/1M6VTxidU2aHZcg1uCFiO0TfCyjVEdKUJEYIFpo4amltNECgYEAsIu6\\ncBQeGAxuJTU1ks8659X8ezRp2+6Fx+HlX0h4V2hZREC45zRuoEK2MIh/HHMnF5Np\\n3SdGArcpl7TnKMjNPx8Da6JXDXc2D9ZS1soRKo14tpRxHd3yPvDLs2Ty5kN88d5f\\nzlg+/FHATU/+EyQN15+c2bpHfhwYCR9HzyH0FR0CgYAWe3sB6aqkBevdGTUwVwW9\\nsFyFE7TnR2C3FDoRk48c2Qvs434pg6LIUr57GMia0yuJ4p6T0F5pvy/U0D3lk4We\\naXwe34JwCyKT/jl/OndmsXykouzS9SRbqv8TH3YOJVmat2v1F577T/x2IKVKQRhF\\ngPynGyhcmi8KDDzcSWCbQQKBgChYdk3guxPh21YTd9/KDfsnUuDRFJQXSWlpfWKu\\nDBpllWjcpaTovZNQS5SBzRKyWi+wF5RbwksikpXB2MXgRc90BfMWEXDZWnh6EUpW\\nuV+RHxISkFsz+oVZwCOKIVxv9eDMYfalAhflkt3YNwcmyScKqeyz/lyajP+gr2dt\\nqfsdAoGAQM7XsP5ozxHsKzeywQinb/r38CDUoSWUyY25NQ5W4mhoZl+0PxppjgMs\\nS/H5/2azZEJ8IFH4brb8STBihZVUrDCdWqzEpmurgm49s+oOPg4DRYQKoZIukjuG\\njWkn0cUqUVUMptIm8fLoqmGmdKjMwlMuSAs3LZiLLcUB4DG/pGM=\\n-----END RSA PRIVATE KEY-----"}'; > sql.sql
mysql mailtrain < sql.sql
rm sql.sql
