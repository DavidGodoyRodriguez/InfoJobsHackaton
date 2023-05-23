# InfoJobs Hackathon - David Godoy
# Español
El proyecto que he decidido desarrollar se basa en una integración compartida con InfoJobs API y OpenAI API, para el procesamiento de curriculums de los candidatos, en una idea de mejorar el rendimiento del personal de recursos humanos cuando deben de procesar cientos o incluso miles de candidatos.

La solución habilita una interfaz flexible con la cual el personal de recursos humanos podrán escribir en lenguaje común cuales son los requisitos que esperan de los candidatos y ChatGPT procesará los curriculums, cruzándolos con las capacidades descritas por recursos humanos. Y todo ello sin las limitaciones que algunas de la herramientas de filtrado actuales posean, ya que se tratan de herramientas estáticas que necesitan un desarrollo incremental para añadir mayor complejidad en los filtros.

He decidido utilizar como plataforma hosting Salesforce, por motivos personales ya que es la tecnología con la que me sentía más cómodo, al ser yo desarrollador Salesforce.

![image info](img/high-level-solution.png)

Pero esta idea se podría perfectamente implentar en una aplicación web independiente, una aplicación móvil o desarrollando un servicio middleware que que exponga mediante API soluciones procesadas por ChatGPT a cualquier consumidor.

## Acceso a la plataforma.
Para acceder a la plataforma tendrás que sencillamente seguir los siguientes pasos:

1. Accede a la URL: https://ebury-f-dev-ed.develop.my.salesforce.com/
2. Utiliza el Username: info.jobs.tester@gmail.com.infojobshackathon
3. Introduce la contraseña que compartiré con vosotros a través de un canal distinto por motivos de seguridad.

## Configuración del acceso a las APIs
Para poder probar la solución, primero hay que introducir los API Keys para las integraciones de InfoJobs y OpenAI, para ello sigue los siguientes pasos:

1. Accede a Setup.
2. Desde el buscador escribir "Custom Metadata Types" y seleccionar la susodicha opción.
3. Seleccionar "Manage Records" al lado de la configuración "Token".
4. Editar ambas configuraciones para InfoJobs y OpenAI, e incluir ambos tokens.
5. Asegurarse de guardar ambas configuraciones.

Tenéis un video en la carpeta /videos del repositorio, mostrando paso a paso como podéis hacer esta configuración.

> La API de OpenAI tiene un plan gratuito para hacer pruebas, podéis crearos una cuenta gratuita, pero tened en cuenta que hay una limitación de 3 llamadas a la API cada 20 segundos, así que tenedlo en cuenta si optáis por el plan gratuito.




