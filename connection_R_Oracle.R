rm(list=ls(all=TRUE)) ##para limpiar memoria

library(readxl) #package para la lectura de los ficheros de Excel 
library(ROracle) #package para la escritura en tablas de Oracle
#library(DBI) 
library(xlsx) #package para escribir en un excel

##creando conexion a Oracle
driver<- Oracle()
driver<- Oracle()
driver <- dbDriver("Oracle")

##asignacion de usuario y contrasena
userBD <- "C##USER01"
passBD <- "user01_123"

host <- "192.168.1.55"
port <- 1521
sid <- "orcl"
connect.string <- paste(
  "(DESCRIPTION=",
  "(ADDRESS=(PROTOCOL=tcp)(HOST=", host, ")(PORT=", port, "))",
  "(CONNECT_DATA=(SID=", sid, ")))", sep = "")
  
##creacion de conexion
connection <- dbConnect(driver, username = userBD , password = passBD ,
                        dbname = connect.string)

##commit de confirmacion de creacion de conexion
dbCommit(connection)

##################################++++++++++++++++++++++++++++++++++++++++++++++++

##importar data de excel para insertar en la tabla 'TEST_CARGA' de oracle
##la estructura de la data del excel es ID_PERSONAL , NOMBRES_APELLIDOS , NACIONALIDAD
data_insertar <- read.xlsx("D:\\Books\\Book03.xlsx", 
                sheetIndex = 1)

##se limpia la data de la tabla TEST_CARGA				
tsql <- paste("TRUNCATE TABLE " , userBD  ,  ".TEST_CARGA", sep="")
queryresult <- dbSendQuery(connection, tsql)
dbCommit(connection)

##se inserta el dataset en la tabla TEST_CARGA de oracle
tsql <- paste("insert into " , userBD , ".TEST_CARGA(ID_PERSONAL , NOMBRES_APELLIDOS , NACIONALIDAD) values (:1, :2, :3)", sep="")
rs <- dbSendQuery(connection, tsql, data = data_insertar)
dbCommit(connection)


##################################++++++++++++++++++++++++++++++++++++++++++++++++


