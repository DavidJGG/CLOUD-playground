docker run -d -p 80:5000/tcp test/pythonapp:v1

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 533267351303.dkr.ecr.us-east-1.amazonaws.com

docker build -t test/pythonapp .

docker tag test/pythonapp:v1 533267351303.dkr.ecr.us-east-1.amazonaws.com/test/pythonapp:v1

docker push 533267351303.dkr.ecr.us-east-1.amazonaws.com/test/pythonapp:v1