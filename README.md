### THIS FILE EXPLAIN WHAT THE PROJECT ENTAILS

###### **AltSchool of Cloud Engineering – Tinyuka 2024 Third Semester  Month 1 Assessment and Resources  Assessment**
### **Semester 3 – Month 1 Assessment**


**Product Concept: CloudLaunch**

**You are working on a lightweight product called CloudLaunch, a platform that showcases a basic company website and stores some internal private documents. You are required to deploy it using AWS core services. This exercise demonstrates your understanding of AWS fundamentals including S3, IAM, and VPCs.**


**Your assessment consists of two main tasks: hosting a static site securely on S3 and designing a VPC network layout.**
*You must implement strict access controls for users and resources.*


## **Task 1: Static Website Hosting Using S3 + IAM User with Limited Permissions**
**Objective: Host a public website and manage private file storage using Amazon S3, and control access via IAM. The website should be a basic webpage for the CloudLauch project. Its content is not important, so much effort is not required.**

*The public access bucket, has the following*

- Cloudlaunch-site-bucket
- Hosts a simple static website (HTML/CSS/JS).
- Enable static website hosting.
- Publicly accessible (read-only for anonymous users).

## Kindly look at the code snippets for more understanding (publicaccessbucket)



*The private access bucket, has the following*

- Cloudlaunch-private-bucket
- Not publicly accessible.
- A designated IAM user (created by you) should have permissions to GetObject and PutObject only (no Delete).

## Kindly look at the code snippets for more understanding (privatebucket)



*The visible only access bucket, has the following*

- Cloudlaunch-visible-only-bucket
- Not publicly accessible.
- The IAM user should be able to list this bucket (see it in S3 list) but not access its contents.

## Kindly look at the code snippets for more understanding (visibleonlybucket)

## Here is the s3 static website url
[s3-website](http://cloud-launch-site-bucket-adetokunbo-julius.s3-website-us-east-1.amazonaws.com)

## Here is the s3 static website url cloudfront
[cloudfront-url](https://d2ciebuzsrx7nb.cloudfront.net)

### The webpage image cloudfront
![webpage](/Task1/publicaccessbucket/julius-cloudfront-webpage.png)



### The working terminal
![terminal-on](/Task1/publicaccessbucket/julius-working-terminal.png)



### The destroyed terminal
![terminal-off](/Task1/publicaccessbucket/julius-destroy-terminal.png)




###### **Task 2: VPC Design for CloudLaunch Environment**
**Objective: Create a secure and logically separated network environment for future expansion (no actual EC2 or NAT needed).**



## VPC Requirements:
## **VPC named: cloudlaunch-vpc**
*CIDR Block: 10.0.0.0/16*

## Subnets:
**Public Subnet (10.0.1.0/24) – Intended for load balancers or future public-facing services.**

**Application Subnet (10.0.2.0/24) – Intended for app servers (private).**

**Database Subnet (10.0.3.0/28) – Intended for RDS-like services (private).**

## Internet Gateway (IGW):
- Create an Internet Gateway named cloudlaunch-igw.
- Attach it to your VPC cloudlaunch-vpc.
- Route Tables

## Route Table for Public Subnet:
- Create a route table named cloudlaunch-public-rt.
- Associate it with the Public Subnet (e.g., cloudlaunch-public-subnet).
- Add a route that sends all internet-bound traffic (0.0.0.0/0) to the Internet Gateway cloudlaunch-igw.

## Private Subnet Route Tables:
- Create separate route tables for the App and DB subnets (cloudlaunch-app-rt, cloudlaunch-db-rt).
- Do not associate these subnets with the Internet Gateway or NAT Gateway.
- Ensure there is no route to 0.0.0.0/0, making them fully private.

## Security Groups:
- Create at least two security groups:
- cloudlaunch-app-sg: allows HTTP (port 80) access within the VPC only.
- cloudlaunch-db-sg: allows MySQL (port 3306) access from app subnet only.

##  IAM Permissions:
*Your IAM user cloudlaunch-user should have read-only (list/view) access to the VPC alone and its components (subnets, route table, security groups).*
