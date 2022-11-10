This is a book management system with a mySQL database. (Work in progress)

See the project structure below:

![image](https://user-images.githubusercontent.com/35563797/200115098-8e7174fe-184d-49ce-a0d1-8a01b46212ca.png)

Run the command ``` go mod init github.com/spiffaz/go-bookstore ```. Replace "spiffaz" with your repo.
Run this to get the gorm package ``` go get "github.com/jinzhu/gorm" ```.
``` go get "github.com/jinzhu/gorm/dialects/mysql" ``` to help us connect with mysql. *
``` go get "github.com/gorilla/mux" ```
go get gorm.io/gorm
go get gorm.io/driver/mysql

(The gomod file helps to have all packages for building when go build is run)

