python3 command2label.py command.json >> Dockerfile
docker build -t xnatworks/dcm2bids-session:2.11 .
docker push xnatworks/dcm2bids-session:2.11
