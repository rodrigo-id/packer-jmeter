# Construir una Imagen con [packer](http://packer.io) en AWS

### Notas

Este directorio tiene dos archivos de packer para construir las imagenes de [Apache JMeter](https://jmeter.apache.org) necesarioas para realizar pruebas de stress con un nodo de master y varios nodes:

* jmeter-master.json
* jmeter-node.json

## Exportar las variables de entorno para el acceso AWS

``` bash
export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```

## Validar el archivo de configuración

Para validar el archivo de configuración se ejecuta: `packer validate jmeter-node.json`

## Construir la imagen

Para construir la imagen en AWS se ejecuta: `packer build jmeter-node.json`