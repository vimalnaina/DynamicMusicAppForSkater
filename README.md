# Dynamic_Music_Player

## Getting Started

This project is a Spring Boot-based dynamic music player designed to integrate with MySQL, Redis, and Kafka, offering robust backend support for dynamic playlist features.

---

using backend server
git checkout 1ad030ebdbf54f0f356f4b10af366321e61c9fd6


## Using Docker

### Run

1. run docker server to provide index.html
```docker run -p 3000:3000 chwan886/flutter```


### Build in frontend

1. build Fronted code using.
```flutter build web```
2. build Fronted code into docker container.
```docker build -t your-docker-username/flutter``` 
3. test the build
```docker run -p 3000:3000 your-docker-username/flutter```
4. push image
```docker push your-docker-username/flutter```

### Build in backend

0. build java-app fit different platform
```docker buildx build --platform linux/amd64,linux/arm64,windows/amd64 -t echo5556/capstone:java-app --push --no-cache .```

or

1. build backend environment int docker container
```docker build -t echo5556/capstone:java-app .```

2. docker login
```docker login```

3. push new file to the docker hub
```docker push echo5556/capstone:java-app   ```

4. run backend side using docker
```docker-compose up```


### Backend Prerequisites

Ensure you have the following dependencies installed:

- **Java**: JDK 8
- **Maven**: For dependency management and building the project
- **MySQL**: Database server
- **Redis**: In-memory data structure store
- **Kafka**: Distributed event streaming platform
- **SSL Configuration**: A `keystore.jks` file properly configured in your classpath

---

## Setup Instructions

### Clone the Repository

Clone the project repository to your local machine:
```bash
git clone https://gitlab.com/rezacourses/engi9837_2024/sportsmusicplayerb/sportsmusicapp.git
cd sportsmusicapp

## 🔧 Configuration

### Database Configuration

Set up a MySQL database named `capstone` with the following credentials:

- **Host**: `127.0.0.1`
- **Port**: `3306`
- **Username**: `root`
- **Password**: `13803535272Byh`

The database schema will be created automatically during application startup if configured correctly.

---

### Redis Configuration

Ensure a Redis server is running with the following settings:

- **Host**: `127.0.0.1`
- **Port**: `6379`

---

### Kafka Configuration

Set up a Kafka broker with the following settings:

- **Bootstrap Server**: `localhost:9092`
- **Group ID**: `group5Test`

---

### Application Profiles

The application is configured to use the `dev` profile by default. You can modify this in the `application.yml` file:

```yaml
spring:
  profiles:
    active: dev


## 🛠 Build and Run

### Building the Project

To build the project, use the following command:

mvn clean install

## Running the Application

Run the application with the default `dev` profile:

mvn spring-boot:run

By default, the server will start at https://localhost:44433.



## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/yuhanbai2001/dynamic_music_player.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/yuhanbai2001/dynamic_music_player/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

```

## Front-End Prerequisites

Before running the project, ensure the following:

1. **Flutter Installed**:
    - Install Flutter by following the official [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).
    - Ensure Flutter is added to your PATH environment variable.

2. **Web Support Enabled**:
    - Ensure Flutter has web support enabled. Run the following command to check:
      ```bash
      flutter devices
      ```
    - If `Chrome` or another web browser is not listed, enable web support:
      ```bash
      flutter config --enable-web
      ```

3. **Chrome Browser Installed**:
    - Install Google Chrome, as it is the default browser used for Flutter web development. Download it from [Google Chrome](https://www.google.com/chrome/).

## Setting Up the Project

1. **Clone the Repository**:
   Clone this repository to your local machine:
   ```bash
   git clone https://gitlab.com/rezacourses/engi9837_2024/sportsmusicplayerb/sportsmusicapp.git
   cd Frontend

2. **Install Dependencies: **:
   Fetch the project dependencies by running:
   ```bash
   flutter pub get

2. **Verify Flutter Configuration: **:
   Run the following command to check for any setup issues:
   ```bash
   flutter doctor

## Running the Project on Web

1. **Run on Chrome:**:
   To start the project on the default web browser (Chrome), use:
   ```bash
   flutter run -d chrome

2. **Run on Specific Web Browser: **:
   To specify a different browser (e.g., Edge), use:
   ```bash
   flutter run -d edge

3. **Build for Release: **:
   To build the project for deployment:
   ```bash
   flutter build web



***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
