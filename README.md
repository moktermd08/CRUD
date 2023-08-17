# CRUD Library

## Introduction

` Database Library` is a Kotlin-based library that simplifies interactions with MySQL databases. It is designed to make it easier to establish connections, execute queries, and perform other common database tasks. The library also includes input sanitization methods to help secure your application from common vulnerabilities such as SQL injection.

Created by Mokter Hossain.

- Email: [mo@gglink.uk](mailto:mo@gglink.uk)
- Website: [www.gglink.uk](https://www.gglink.uk)
- GitHub: [moktermd08](https://github.com/moktermd08)
- LinkedIn: [mr-mokter](https://www.linkedin.com/in/mr-mokter/)
- Twitter: [moGGLink](https://twitter.com/moGGLink)

## Setup

To start using this library, add it as a dependency to your Kotlin project.

### Add the MySQL JDBC Driver

To interact with MySQL databases, you need to include the MySQL JDBC driver in your project's dependencies.

```gradle
dependencies {
    implementation 'mysql:mysql-connector-java:8.0.23'
}
