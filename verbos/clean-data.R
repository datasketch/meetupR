library(tidyverse)

# Esta librería es un paquete que contiene otros paquetes que sirven
# para leer datos (readr), realizar tablas y/o convertir listas u otros
# formatos en tablas (tibble), organizar y limpiar bases de datos (tidyr), 
# expresiones regulares (stringr), realizar operaciones en bases o entre
# bases (dplyr), visualizaciones (ggplot2) y opciones más avanzadas de
# programación funcional (purrr)



# Lectura de base de datos ------------------------------------------------

# Esta base contiene información de candidatos a congreso 2018 en Colombia
# y de sus respectivos financiadores.
congreso <- read_csv('data/data_meetup_congreso.csv')

# Puede explorar la base mirando las categorías dentro de cada
# variable con "unique", este comando le imprime las únicas categorías
# que hay dentro de cada variable

unique(congreso$`Corporación o Cargo`)

# puede guardar el resultado:

categoriasCargo <- unique(congreso$`Corporación o Cargo`)
categoriasCargo

# Verbos de limpieza...

# 1. unite y united
# Ambas funciones cumplen la misma finalidad y es unir una o
# más columnas en una sola. 
# Por ejemplo, supongamos que queremos tener en una misma columna
# Departamento de ingreso y ciudad de ingreso

# La nueva columna con la respectiva unión se llamará unionDeptos
union1 <- unite(congreso, 
                unionDeptos, 
                `Departamento Ingreso`, `Ciudad Ingreso`, sep = '. Ciudad: ')


# ahora hay una nueva columna con la unión correspondiente y 
# las columnas `Departamento Ingreso` y `Ciudad Ingreso` se 
# eliminan de la base.

names(union1)
unique(union1$unionDeptos)

# Ahora si no se quiere remover las columnas de la unión se agrega
# el argumento remove = FALSE
union1 <- unite(congreso, 
                unionDeptos, 
                c(`Departamento Ingreso`, `Ciudad Ingreso`), 
                sep = '. Ciudad: ',
                remove = FALSE)
names(union1)

# union_ se diferencia de unión en que los parámetros de la 
# función van en comillas:
union1 <- unite_(congreso, 
                 'unionDeptos', 
                c('Departamento Ingreso', 'Ciudad Ingreso'), 
                sep = '. Ciudad: ')


# 2. separate y separate_
# Esta función es lo contrario a la anterior y sirve para separar
# datos en x columnas.
# Por ejemplo, supongamos que la variable "Fecha Registro Movimiento" 
# este separada el columnas por Año, mes y día


sepFecha <- separate(congreso, 
                     `Fecha Registro Movimiento`,
                     c('Año', 'Mes', 'Día'), #NOMBRE DE LAS NUEVAS COLUMNAS 
                     sep = '-')
unique(sepFecha$Año)
unique(sepFecha$Día)
unique(sepFecha$Mes)

# Importante: si no pone todos los nombres de las posibles 
# columnas en la consola le saldrá un "Warning message" y 
# no le separará todas las columnas 
sepFechaM <- separate(congreso, 
                     `Fecha Registro Movimiento`,
                     c('Año', 'Mes'), #NOMBRE DE LAS NUEVAS COLUMNAS 
                     sep = '-')

# también puede usar el argumento "extra" que permite tener más control
# sobre la función:
# "warn" (es la salida por defecto): da como salida un "warning" y elimina las otras posibles columnas
# "drop": Elimina los valores extras pero no sale el mensaje de "warning"
# "merge": En la última columna pega todo lo que no quedó nombrado

sepFechaM <- separate(congreso, 
                      `Fecha Registro Movimiento`,
                      c('Año', 'Mes'), 
                      sep = '-', extra = 'merge')
unique(sepFecha$Año)
unique(sepFecha$Mes)

# 3. select
# Esta función selecciona o elimina las variables que desee
# Ejemplo: suponga que 

# seleccionar
selec1 <- select(congreso, `Identificacion Candidato` , `Tipo Donacion`, Valor)
selec2 <- select(congreso, 1, 5, 9)
# eliminar
selec3 <- select(congreso, -(1:10))
selec4 <- select(congreso, -`Corporación o Cargo`)



# 3. spread
# Esta función vuelve una columna en múltiples columnas.
# Ejemplo: 
selec1 <- distinct(selec1, `Identificacion Candidato`, .keep_all = TRUE) 
dataSpread <- spread(selec1, `Tipo Donacion`, Valor)


# 4. gather
# Esta función vuelve múltiples columnas en una sola columna
dataGather <- gather(dataSpread, TipoDon, Valor, -`Identificacion Candidato`)

# 5. filter
# Esta función permite realizar filtros en una o más columnas

de <- filter(congreso, `Tipo Donacion` == 'Donación en especie')
difde <- filter(congreso, `Tipo Donacion` != 'Donación en especie')
fiper <- filter(congreso, `Tipo Donacion` %in% c('Aporte', 'Contribución'))



# Ejercicio:

# En la carpeta 'dataActividad' se encuentra un archivo del
# banco mundial que contiene información sobre Tasa de 
# incidencia de la pobreza, sobre la base de $1,90 por día 
# (2011 PPA) (% de la población)

# 1. Eliminar la FILA 'mundo' de la columna 'Country Name' <- recuerda que para que la base de datos quede limpia y lista para analizar las filas deben ser independientes y las filas no deben ser totales u operaciones de las demás
# 2. Eliminar las COLUMNAS 'Country Code', 'Indicator Name' y 'Indicator Code'
# 3. Realizar un gather para que los años queden en una sola columna llamada "Años" y la tasa de pobreza en una columna llamada 'Indicador'
# 4. Eliminar registros donde el indicador sea NA (pista drop_na)
# 5. Cree un vector llamado 'NuevaBase' y haga un spread donde los paises estaran en una columna independiente
# Si tiene preguntas cree cuenta en gitHub y ponen un "ISSUE" en el repositorio.




