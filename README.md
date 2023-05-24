# InfoJobs Hackathon - David Godoy

## Idea

El proyecto se basa en una interfaz que mostrará al personal de selección de ofertas en InfoJobs las ofertas existentes y candidatos que hayan aplicado a ellas. Extendiendo con una nueva funcionalidad basada en ChatGPT, que permitirá a los seleccionadores especificar cuales son las capacidades deseadas para la oferta y realizará una operación de filtrado de forma automática.

El proyecto se basa en una integración compartida entre InfoJobs API y OpenAI API, utilizando como hosting la plataforma Salesforce como intermediaria entre ambas y mostrando los resultados en la web.

![image info](img/high-level-solution.png)

Pero esta idea se podría perfectamente implentar en una aplicación web independiente, una aplicación móvil o desarrollando un servicio middleware que que exponga mediante API soluciones procesadas por ChatGPT a cualquier consumidor.

> La API de OpenAI que he utilizado es un plan gratuito que sólo permite hacer 3 llamadas a gpt-3.5-turbo por minuto, por lo que he limitado las interacciones del usuario con GPT para evitar sobrecargar la API.

## Tecnologías usadas
- InfoJobs API
- Salesforce Public Sites
- Apex
- LWC
- OpenAI API

## Prueba de la aplicación web

### Seleccionar Oferta
Al entrar en la web se puede encontrar un campo en el que incluir el ID de la oferta que se quiere cargar.

![image info](img/get-oferta.png)

### Listado de candidatos

Al cargar una oferta, también veremos candidatos asociados a dicha oferta (datos mockeados por privacidad), también veremos detalles de los curriculums de dichos candidatos.

![image info](img/candidates-list.png)


### Análisis ChatGPT

Cuando se introduzcan datos específicos sobre las capacidades o requisitos que el seleccionador desee filtrar sobre todos los candidatos, ChatGPT hará un análisis cruzando los requisitos con los datos de los curriculums de los candidatos, y así marcando candidatos que cumplan con dichas condiciones. 

Además, también se podrán ver las valoraciones realizadas por ChatGPT sobre cada uno de los candidatos, ya hayan sido seleccionados o descartados.

![image info](img/ia-analysis.png)
