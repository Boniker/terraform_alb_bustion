# Terraform
ALB + Bustion host + VPC + SG

## About the program

1. Created a new ssh key in the EC2 console.

2. Created a hopping host t4g.nano on a public subnet with SSH access from anywhere.

3. Created a host on a private subnet. It should be accessible from SG jump host over SSH and from SG for load balancer between 8000-9000.

4. Installed docker on it and ran the two content with nginx. Threw port 80 of the containers to ports 8080 and 8081 respectively.

5. Created an ALB with port 80 input and two rules:

- The /app1 path should answer the first container.

- The /app2 path should respond to the second container.

6. The load balancer should be accessible from all ip only on port 80.