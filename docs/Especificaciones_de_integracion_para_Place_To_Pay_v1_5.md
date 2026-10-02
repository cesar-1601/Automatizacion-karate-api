![LOGO](media/image1.png){width="4.657638888888889in" height="0.3423611111111111in"}

**Control de versiones**

<table style="width:100%;">
<colgroup>
<col style="width: 10%" />
<col style="width: 24%" />
<col style="width: 15%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Versión</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Autor</strong></th>
<th><strong>Fecha</strong></th>
<th><strong>Aprobado por</strong></th>
<th><strong>Fecha de aprobación</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1.0</td>
<td>Versión Inicial</td>
<td>Franklin Pérez</td>
<td>23/05/2024</td>
<td>Paúl Chamorro</td>
<td>23/05/2024</td>
</tr>
<tr class="even">
<td>1.1</td>
<td><p>Actualización de endpoints y</p>
<p>Puntualizaciones sobre el proceso de cifrado</p></td>
<td>Gabriel Villacis</td>
<td>20/09/2024</td>
<td>Jenny Pilco</td>
<td>23/09/2024</td>
</tr>
<tr class="odd">
<td>1.2</td>
<td>Inclusión de código de error para tarjetas inválidas en los servicios de generación/validación de OTP y se ajusta el formato de salida del campo montoInteres en servicio de autorización de consumo</td>
<td>Gabriel Villacis</td>
<td>29/11/2024</td>
<td>Jenny Pilco</td>
<td>29/11/2024</td>
</tr>
<tr class="even">
<td>1.3</td>
<td>Ajuste en campos para procesos: pre-autorizaciones y tokenización en servicio autorización-consumos (sección 4.1.6)</td>
<td>Wilson Castro</td>
<td>07/02/2025</td>
<td>Fernanda Jácome</td>
<td>10/02/2025</td>
</tr>
<tr class="odd">
<td>1.4</td>
<td>Actualización sección 4.3 Anexos</td>
<td>Wilson Castro</td>
<td>27/02/2025</td>
<td>Fernanda Jácome</td>
<td>27/02/2025</td>
</tr>
<tr class="even">
<td>1.5</td>
<td>Actualización proceso de encriptación sección 4.2</td>
<td>Wilson Castro</td>
<td>26/03/2025</td>
<td>Fernanda Jácome</td>
<td>28/03/2025</td>
</tr>
</tbody>
</table>

# Contenido {#contenido .TOC-Heading .unnumbered}

[1. Introducción: [3](#introducción)](#introducción)

[2. Definiciones y Abreviaturas [3](#definiciones-y-abreviaturas)](#definiciones-y-abreviaturas)

[3. Arquitectura de Integración: [5](#arquitectura-de-integración)](#arquitectura-de-integración)

[4. Descripción General de los Servicios [7](#descripción-general-de-los-servicios)](#descripción-general-de-los-servicios)

[4.1. Detalle de los Endpoints [7](#detalle-de-los-endpoints)](#detalle-de-los-endpoints)

[4.1.1. Consultar llave RSA pública [7](#consultar-llave-rsa-pública)](#consultar-llave-rsa-pública)

[4.1.2. Generar OTP: [10](#generar-otp)](#generar-otp)

[4.1.3. Validar OTP: [15](#validar-otp)](#validar-otp)

[4.1.4. Consultar tipos de crédito: [20](#consultar-tipos-de-crédito)](#consultar-tipos-de-crédito)

[4.1.5. Cálcular interés: [25](#cálcular-interés)](#cálcular-interés)

[4.1.6. Autorización de consumo [31](#autorización-de-consumo)](#autorización-de-consumo)

[4.1.7. Body cifrado en peticiones/respuestas [41](#body-cifrado-en-peticionesrespuestas)](#body-cifrado-en-peticionesrespuestas)

[4.2. Estándar de cifrado [43](#estándar-de-cifrado)](#estándar-de-cifrado)

[4.3. Anexos sobre la definición de campos en las peticiones/respuestas [47](#_Toc194301798)](#_Toc194301798)

[4.3.1. Detalles de estructura DinHeader [47](#detalles-de-estructura-dinheader)](#detalles-de-estructura-dinheader)

[4.3.2. Detalles de estructura DinError [49](#detalles-de-estructura-dinerror)](#detalles-de-estructura-dinerror)

[4.3.3. Campos del servicio de autorización de consumo [49](#campos-del-servicio-de-autorización-de-consumo)](#campos-del-servicio-de-autorización-de-consumo)

# Introducción:

Actualmente, Diners Club, como parte de los servicios que presta a varias pasarelas (botones) de pago, expone una serie de servicios REST que permiten realizar transacciones financieras, específicamente transacciones con tarjetas de crédito y débito, de manera segura y eficiente.

Estos servicios incluyen funcionalidades clave como:

-   Consulta de llave RSA pública

-   Generación de OTP (One-Time Password)

-   Validación de OTP

-   Consulta de tipos de crédito

-   Cálculo de intereses

-   Autorización de consumo

Este documento describe las especificaciones técnicas necesarias para la integración de los servicios REST de Diners Club con pasarelas de pago, proporcionando a los desarrolladores la información detallada sobre los endpoints, los métodos HTTP, las estructuras de solicitud y respuesta, y la encriptación de datos, que será una prioridad en esta integración.

El objetivo principal es garantizar que las pasarelas de pago, como **Place To Pay**, puedan consumir estos servicios de forma segura, cumpliendo con altos estándares de seguridad, confiabilidad y eficiencia en las transacciones con tarjetas de crédito y débito.

# Definiciones y Abreviaturas

-   **MICROSERVICIO:** Servicio independiente y operativo que forma parte de una arquitectura de software distribuida. Cada microservicio maneja una función específica y se comunica con otros servicios a través de APIs, permitiendo escalabilidad y mantenimiento ágil.

-   **API:** Interfaz de Programación de Aplicaciones (Application Programming Interface). Las APIs permiten que los microservicios se comuniquen entre sí y con otros sistemas, facilitando la integración y la interoperabilidad.

-   **REST:** Transferencia de Estado Representacional (Representational State Transfer). Es un estilo arquitectónico utilizado por microservicios para la comunicación a través de HTTP, aprovechando los métodos estándar como GET, POST, PUT y DELETE para operar sobre los recursos.

-   **JSON:** Notación de Objetos de JavaScript (JavaScript Object Notation). Formato de intercambio de datos ampliamente utilizado en microservicios para transmitir información entre servicios debido a su simplicidad y legibilidad.

-   **DATAPOWER:** Gateway especializado que actúa en el borde de la red, gestionando la seguridad, integración y optimización de datos. Su función principal es inspeccionar, filtrar y enrutar el tráfico de red de forma segura, garantizando la protección de servicios expuestos a través de APIs, autenticación, y políticas de cifrado en tiempo real.

-   **OPENSHIFT:** Plataforma de contenedores basada en Kubernetes, que permite desarrollar, desplegar y gestionar aplicaciones (microservicios) en la nube de manera eficiente.

-   **CIFRADO**: Proceso de transformar datos en un formato ilegible para proteger su confidencialidad durante la transmisión o almacenamiento.

    -   **Cifrado Simétrico**: Tipo de cifrado en el que la misma clave se usa tanto para encriptar como para desencriptar los datos.

    -   **Cifrado Asimétrico**: Tipo de cifrado que utiliza un par de claves (pública y privada); la clave pública cifra los datos y la clave privada los descifra.

-   **AES**: Estándar de cifrado avanzado (Advanced Encryption Standard), utilizado ampliamente para proteger datos mediante cifrado simétrico.

```{=html}
<!-- -->
```
-   **AES-256 modo GCM:** Algoritmo de cifrado simétrico que proporciona autenticación integrada mediante un MAC, permite cifrado paralelo. Utiliza un vector de inicialización (IV) único, incluso si los bloques de datos son idénticos, el resultado cifrado será diferente. Teniendo alta resistencia a ataques de manipulación y análisis de patrones.

```{=html}
<!-- -->
```
-   **RSA**: Algoritmo de cifrado asimétrico utilizado para proteger información mediante claves públicas y privadas.

# Arquitectura de Integración:

![](media/image2.png){width="5.402075678040245in" height="3.707891513560805in"}

Nuestra solución de integración está diseñada con un enfoque en la seguridad, eficiencia y escalabilidad, utilizando una arquitectura de microservicios desplegada en OpenShift. Estos microservicios exponen APIs REST que pueden ser consumidos por cualquier pasarela de pagos para realizar transacciones financieras seguras mediante tarjetas de crédito y débito.

En nuestra arquitectura, cada uno de estos servicios cuenta con mecanismos de cifrado para proteger la confidencialidad de los datos sensibles que se manejan durante las transacciones. La comunicación hacia nuestras APIs se realiza a través de DataPower, que agrega una capa adicional de seguridad mediante el cifrado completo de la trama del body de las peticiones, asegurando que toda la información que viaja a través de la red esté protegida de accesos no autorizados.

**Protección de Datos Sensibles**

Uno de los pilares fundamentales de esta integración es el cifrado de campos sensibles dentro de cada solicitud. La pasarela de pagos debe implementar el cifrado de campos clave como:

-   Número de tarjeta

-   CVV

-   Fecha de expiración

-   OTP

-   Otros campos sensibles

Estos campos deben ser cifrados antes de enviar la solicitud, y, posteriormente, todo el body de la petición deberá ser cifrado en su totalidad. Para más detalles sobre los algoritmos de cifrado y su implementación, consulte el apartado [Estándar de cifrado](#estándar-de-cifrado) más abajo.

**DataPower: Una Capa Adicional de Seguridad**

DataPower actúa como gateway de seguridad y protección, gestionando el tráfico entre la pasarela de pagos y nuestros microservicios en OpenShift. Este componente no solo verifica la autenticidad de las solicitudes, sino que también desencripta las peticiones y vuelve a cifrar las respuestas, asegurando que los datos sensibles permanezcan protegidos en todo momento. Además, el cifrado completo del body de las peticiones añade una capa adicional de protección contra ataques de interceptación o manipulación de datos.

**Beneficios de esta Arquitectura:**

-   **Confidencialidad:** Garantizamos que los datos sensibles (número de tarjeta, CVV, etc.) nunca viajen sin cifrar.

-   **Integridad:** El cifrado completo del body asegura que los datos no puedan ser alterados durante la transmisión.

-   **Escalabilidad:** La arquitectura basada en microservicios permite una integración ágil, con APIs independientes que pueden ser escaladas según la demanda.

Esta estrategia de integración está diseñada para ofrecer una solución segura y flexible, permitiendo que cualquier integrador implemente y consuma nuestros servicios de forma eficiente, garantizando la protección de los datos sensibles en cada transacción.

# Descripción General de los Servicios

## Detalle de los Endpoints

A continuación, se listan los servicios que la pasarela debe consumir para realizar la integración, incluyendo los endpoints del ambiente de pruebas en el que se llevará a cabo el desarrollo. Los servicios expuestos implementan el estándar REST, y son los siguientes:

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **Servicio**                  **URL Ambiente No Productivo (CAL)**                                                                       **Cifrado body completo**   **LlaveSimetrica en respuesta**
  ----------------------------- ---------------------------------------------------------------------------------------------------------- --------------------------- ---------------------------------
  Consultar llave RSA pública   <http://10.10.176.150:8299/seguridad/cal/canales/llaves-publicas/consulta>                                 NO                          NO

  Generar OTP                   <http://10.10.176.150:8299/placetopay/calidad/seguridad/v1/otp-boton/generar>                              SI                          NO

  Validar OTP                   <http://10.10.176.150:8299/placetopay/calidad/seguridad/v1/otp-boton/validar>                              SI                          NO

  Consultar tipos de crédito    <http://10.10.176.150:8299/placetopay/calidad/tarjetas/v1/parametros-autorizacion/formaspagos/consultar>   SI                          SI

  Calcular interés              <http://10.10.176.150:8299/placetopay/calidad/tarjetas/v1/parametros-autorizacion/interes/calcular>        SI                          SI

  Autorizar consumo             <http://10.10.176.150:8299/placetopay/calidad/tarjetas/v1/consumos/autorizar>                              SI                          SI
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Además, se especifican los detalles de los contratos (campos de peticiones/respuestas) de cada servicio. Es importante destacar que todas las peticiones contienen una estructura genérica denominada **dinHeader**, que es igual y obligatoria para todas las solicitudes. Por otro lado, el **dinBody** es personalizado en función de cada servicio y contiene los campos específicos que varían según la operación a realizar.

Para más detalles sobre la estructura del dinHeader y su implementación, consultar el apartado [Detalles de estructura DinHeader](#detalles-de-estructura-dinheader).

Es necesario tener en cuenta que, al generar las peticiones, todo el body debe estar cifrado, a excepción del servicio de Consultar llave RSA pública. Se recomienda consultar el apartado [Estándar de cifrado](#estándar-de-cifrado) para conocer las especificaciones requeridas para el intercambio seguro de información.

### Consultar llave RSA pública

Este servicio permite la consulta de la llave pública de Diners asignada a la pasarela, Diners almacena la llave por canal y aplicación y sirve para que el consumidor del servicio (pasarela) encripte la llave simétrica con la cual encripta la petición de los servicios y los campos sensibles de forma individual tales como número de tarjeta, CVV, fecha de expiración, clave OTP, entre otros.

*Method: POST*

*Content-Type: application/json*

**Entrada:**

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 10%" />
<col style="width: 6%" />
<col style="width: 7%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td><p><strong>Cabecera</strong></p>
<p><strong>estándar de mensaje</strong></p></td>
<td>Los campos aplicacionId y canalId son indispensables para la obtención de la llave pública correspondiente</td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>null</td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 11%" />
<col style="width: 10%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 29%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><strong>Cabecera estándar de mensaje</strong></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>llavePublica</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Variable</td>
<td>Llave RSA pública asociada a la aplicacionId y canalId consultados</td>
<td><p>Ejemplo:</p>
<p>MIIBIjANBgkqhkiG9w0</p>
<p>BAQEFAAOCAQ8AMIIBCgKCA</p>
<p>QEApQlx4qVVVzzMju4hrgbgn2Zi6v</p>
<p>VgM5hpL8l0c9QUloVeTNKaI40Do8</p>
<p>orVUczqWZrJsDXez7ddQwlDRwu3H</p>
<p>wXwfXNFxwRT9o5YoAYDnqkgzuGaR</p>
<p>tslTMrrRODvS+CThet1edJiyFQOPW</p>
<p>na+Dxwzpr5xB+LS2S+jjrfvQLt28v6ptgS</p>
<p>VzAKPaqOedZw84UOksaLUViyy6FR38</p>
<p>WiyhTukJ+SDlXK6DaauAeOx7Q15Ui6L</p>
<p>m1KNP0Gu1xprOQuZGUneppLWqsZj</p>
<p>OMUXmG59XRuVukJHkjSgSMa1vrfpN</p>
<p>V9urfvjWlPywWzoAIfc368hnY5+tziqm</p>
<p>A/zim9DGyTu7F5Q13RQIDAQAB</p></td>
</tr>
<tr class="even">
<td><strong>DinError *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><strong>DinError estándar de respuesta</strong></td>
<td></td>
</tr>
</tbody>
</table>

**Mensajes de error:**

  ---------------------------------------------------------------------------
  **Código Error**   **Descripción**
  ------------------ --------------------------------------------------------
  9995               El aplicacionId es requerido

  9996               El canalId es requerido

  9999               Error en llave pública
  ---------------------------------------------------------------------------

**Ejemplo de request (Caso exitoso):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": null

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"llavePublica\": \"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA38df2Vtd4E3cADaoAce7KHXjQ9mzVTj6DfDa16jb64yh2/M2hTj2wrt1aJ3sdGkdYfPLMz3XpL5rP2/GlRMmdZsUsP6ODvlYuFTyiTTpWMEKCTBJ02WalffA9S/nnc08lCFTZJDPAjRCrLuTmU1GP1qbdhWH7PXiZAXoDvY3Itj/nH7MGKXnlwjLZ4bEPf9QIEa0QCnwt0pJq5t+wOntT39z+5yh+cg5my5uIUiDzQxgcBkBtY8oooZ+Kv6dd0tlPFOQ/N/4sW6OtbwinYkhfL4TyxjzYJH2vzQqdiN56ajO5O/fTZOoPSqakNWOtz8cEEwRAi4casn1PaRhD3SBEwIDAQAB\"

},

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2024-04-17T21:31:38.993GMT\",

\"origen\": null,

\"codigo\": \"0000\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"OK\",

\"detalle\": \"OK\"

}

}

**Ejemplo de request (Caso fallido):**

{

\"dinHeader\": {

\"aplicacionId\": \"\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": null

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": null,

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T12:41:13.763ECT\",

\"origen\": \"msd-can-int-llavespublicas\",

\"codigo\": \"9995\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"El AplicacionId es Requerido\",

\"detalle\": \"\"

}

}

### Generar OTP:

Este servicio genera y notifica la OTP al cliente a través de SMS y/o correo electrónico, que permite autenticar la autorización de un consumo por parte del cliente utilizando el servicio y proveedor interno o externo correspondiente según el caso.

*Method: POST*

*Content-Type: application/json*

**Entrada:**

<table>
<colgroup>
<col style="width: 18%" />
<col style="width: 9%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 9%" />
<col style="width: 14%" />
<col style="width: 22%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td><p><strong>Cabecera</strong></p>
<p><strong>estándar de mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>perfil</strong></td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El perfil del cliente</td>
<td><p>Valores posibles:</p>
<p>S=Natural</p>
<p>E=Juridico</p></td>
</tr>
<tr class="even">
<td><strong>usuarioBiometricoEncri ptado</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Opcional</td>
<td><p>El usuario biométrico encriptado del cliente.</p>
<p>La longitud máxima del valor en claro es 16.</p></td>
<td><p>Ejemplo: QuJyRk8yA2QBW4dZ aBtaKw==</p>
<p>Ejemplo de valor en claro:</p>
<p>juanPerez80</p></td>
</tr>
<tr class="odd">
<td><strong>codigoTransaccion</strong></td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El código de transaccion</td>
<td><p>Ejemplo:</p>
<p>PTP= Place To Pay</p></td>
</tr>
<tr class="even">
<td><strong>tarjetaEncriptada</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td><p>La tarjeta encriptada del cliente.</p>
<p>La longitud máxima del valor en claro es 22.</p></td>
<td><p>Ejemplo:</p>
<p>Pnr2TclSjqqQtKTvS85 p6Q==</p></td>
</tr>
<tr class="odd">
<td><strong>codigoEntidad</strong></td>
<td>String</td>
<td>2</td>
<td></td>
<td></td>
<td>Opcional</td>
<td>El código de entidad de la tarjeta</td>
<td><p>Ejemplos: DC=Diners</p>
<p>ID=Interdin</p></td>
</tr>
<tr class="even">
<td><strong>codigoMarca</strong></td>
<td>String</td>
<td>2</td>
<td></td>
<td></td>
<td>Opcional</td>
<td>El código de marca de la tarjeta</td>
<td><p>Ejemplos: DN=Diners, VI=Visa, DI=Discover,</p>
<p>MC=Mastercard</p></td>
</tr>
<tr class="odd">
<td><strong>tipoTarjeta</strong></td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El tipo de tarjeta</td>
<td><p>Valores posibles:</p>
<p>C=Crédito D=Débito</p></td>
</tr>
<tr class="even">
<td><strong>parametrosAdicionales</strong></td>
<td>Lista</td>
<td></td>
<td></td>
<td></td>
<td>Opcional</td>
<td>La lista de parámetros adicionales</td>
<td></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 13%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th colspan="8"><strong>Estructura ParámetrosAdicionales</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>Campo</strong></td>
<td><strong>Tipo</strong></td>
<td><strong>Long. entera</strong></td>
<td><strong>Long. decimal</strong></td>
<td><strong>Formato</strong></td>
<td><strong>Mandato</strong></td>
<td><strong>Descripción</strong></td>
<td><strong>Valor</strong></td>
</tr>
<tr class="even">
<td><strong>clave</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>La clave del parámetro</td>
<td><p>Ejemplo:</p>
<p>Param_Adicional_1</p></td>
</tr>
<tr class="odd">
<td><strong>valor</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>El valor del parámetro</td>
<td><p>Ejemplo:</p>
<p>1231</p></td>
</tr>
<tr class="even">
<td><strong>tipo</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>El tipo de dato del parámetro</td>
<td><p>Valores posibles: STRING=Texto INT=Entero BOOLEAN=Booleano</p>
<p>DECIMAL=Decimal</p></td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><blockquote>
<p><strong>Valor</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>Cabecera estándar de</strong></p>
<p><strong>mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>respuestaSolicitud</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>El código de respuesta</td>
<td><p><strong>Valores posibles:</strong></p>
<p><strong>0=Éxito</strong></p></td>
</tr>
<tr class="even">
<td><strong>DinError *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>DinError estándar de</strong></p>
<p><strong>respuesta</strong></p></td>
<td></td>
</tr>
</tbody>
</table>

**Mensajes de error:**

  -------------------------------------------------------------------------------
  **Código Error**   **Descripción**
  ------------------ ------------------------------------------------------------
  0001               El valor del campo perfil es requerido

  0002               La longitud del valor perfil es mayor a 1.

  0003               El valor del campo codigoTransaccion es requerido.

  0004               La longitud del valor codigoTransaccion es mayor a 3.

  0005               El valor del campo tarjetaEncriptada es requerido.

  0006               La longitud del valor codigoEntidad es mayor a 2

  0007               La longitud del valor codigoMarca es mayor a 2

  0008               El valor del campo tipoTarjeta es requerido.

  0009               La longitud del valor tipoTarjeta es mayor a 1.

  9994               Tarjeta no encontrada

  9995               El AplicacionId es Requerido

  9996               El CanalId es Requerido

  9997               Error en el Descifrado de datos

  9998               Error en el cifrado de datos

  9999               Error en criptografía

  0010               El campo perfil no cumple con la expresión requerida S o E
  -------------------------------------------------------------------------------

**Ejemplo de request (Caso exitoso):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"\",

\"dispositivo\": \"ClienteJS\",

\"idioma\": \"es\",

\"portalId\": \"WILTEST\",

\"uuid\": \"c9751174-0864-46f7-85c4-ea3d542e2919\",

\"ip\": \"10.100.62.114\",

\"horaTransaccion\": \"2025-02-18T20:04:57.785Z\",

\"llaveSimetrica\": \"Hxj5ECo3tapivNYKw4V6rHiddYZ3TO5E4s0nqBHUx7c2ofheLs/vfpQZ4QSXYMvijtg472PzYBTye/qf6PydqhygRY3xZGLDTOjWJGJHI4eHexwaOBUa4UK+FJ+mwLJCzC+2FYJ2f2VjaGbrYRlONgcJSCAViT1c/CJ3qZLK+72jiMDBnwoOIY8HbR8Vqq9a/L7euwXyiMAalbMXLH9aO3kVTr2SEmTtF0e3l9Unc/t+V1ao+OFNPrOI9w1sSisUx9tB8A1HsRW0/yUeLi009fHoo5F74V4s7ge4ETW5mwrvAuPpvOY6crJIrlZTfb2M30/2/6/b5QQDaYISE9y3xA==\",

\"usuario\": \"testUser\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[

{

\"clave\": \"\",

\"valor\": \"\"

}

\]

},

\"dinBody\": {

\"perfil\": \"S\",

\"usuarioBiometricoEncriptado\": \"\",

\"codigoTransaccion\": \"PTP\",

\"tarjetaEncriptada\": \"UPBOGCVHPoVKn9QmA11usjA5xGH4Bcic/j0CH4ZiP3247Zu/BHPpTL3wBrI=\",

\"codigoEntidad\": \"RU\",

\"codigoMarca\": \"VI\",

\"tipoTarjeta\": \"D\",

\"parametrosAdicionales\": \[\]

}

}

**Respuesta:**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"\",

\"dispositivo\": \"ClienteJS\",

\"idioma\": \"es\",

\"portalId\": \"PBR\",

\"uuid\": \"c9751174-0864-46f7-85c4-ea3d542e2919\",

\"ip\": \"10.100.62.114\",

\"horaTransaccion\": \"2025-02-18T20:04:57.785Z\",

\"llaveSimetrica\": \"Hxj5ECo3tapivNYKw4V6rHiddYZ3TO5E4s0nqBHUx7c2ofheLs/vfpQZ4QSXYMvijtg472PzYBTye/qf6PydqhygRY3xZGLDTOjWJGJHI4eHexwaOBUa4UK+FJ+mwLJCzC+2FYJ2f2VjaGbrYRlONgcJSCAViT1c/CJ3qZLK+72jiMDBnwoOIY8HbR8Vqq9a/L7euwXyiMAalbMXLH9aO3kVTr2SEmTtF0e3l9Unc/t+V1ao+OFNPrOI9w1sSisUx9tB8A1HsRW0/yUeLi009fHoo5F74V4s7ge4ETW5mwrvAuPpvOY6crJIrlZTfb2M30/2/6/b5QQDaYISE9y3xA==\",

\"usuario\": \"testUser\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[

{

\"clave\": \"\",

\"valor\": \"\"

}

\]

},

\"dinBody\": {

\"respuestaSolicitud\": \"0\"

},

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T10:34:57.423ECT\",

\"origen\": null,

\"codigo\": \"0000\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"OK\",

\"detalle\": \"OK\"

}

}

**Ejemplo de request (Caso fallido):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"\",

\"dispositivo\": \"ClienteJS\",

\"idioma\": \"es\",

\"portalId\": \"WILTEST\",

\"uuid\": \"c9751174-0864-46f7-85c4-ea3d542e2919\",

\"ip\": \"10.100.62.114\",

\"horaTransaccion\": \"2025-02-18T20:04:57.785Z\",

\"llaveSimetrica\": \"Hxj5ECo3tapivNYKw4V6rHiddYZ3TO5E4s0nqBHUx7c2ofheLs/vfpQZ4QSXYMvijtg472PzYBTye/qf6PydqhygRY3xZGLDTOjWJGJHI4eHexwaOBUa4UK+FJ+mwLJCzC+2FYJ2f2VjaGbrYRlONgcJSCAViT1c/CJ3qZLK+72jiMDBnwoOIY8HbR8Vqq9a/L7euwXyiMAalbMXLH9aO3kVTr2SEmTtF0e3l9Unc/t+V1ao+OFNPrOI9w1sSisUx9tB8A1HsRW0/yUeLi009fHoo5F74V4s7ge4ETW5mwrvAuPpvOY6crJIrlZTfb2M30/2/6/b5QQDaYISE9y3xA==\",

\"usuario\": \"testUser\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[

{

\"clave\": \"\",

\"valor\": \"\"

}

\]

},

\"dinBody\": {

\"perfil\": \"S\",

\"usuarioBiometricoEncriptado\": \"\",

\"codigoTransaccion\": \"\",

\"tarjetaEncriptada\": \"UPBOGCVHPoVKn9QmA11usjA5xGH4Bcic/j0CH4ZiP3247Zu/BHPpTL3wBrI=\",

\"codigoEntidad\": \"RU\",

\"codigoMarca\": \"VI\",

\"tipoTarjeta\": \"D\",

\"parametrosAdicionales\": \[\]

}

}

**Respuesta:**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"\",

\"dispositivo\": \"ClienteJS\",

\"idioma\": \"es\",

\"portalId\": \"WILTEST\",

\"uuid\": \"c9751174-0864-46f7-85c4-ea3d542e2919\",

\"ip\": \"10.100.62.114\",

\"horaTransaccion\": \"2025-02-18T20:04:57.785Z\",

\"llaveSimetrica\": \"Hxj5ECo3tapivNYKw4V6rHiddYZ3TO5E4s0nqBHUx7c2ofheLs/vfpQZ4QSXYMvijtg472PzYBTye/qf6PydqhygRY3xZGLDTOjWJGJHI4eHexwaOBUa4UK+FJ+mwLJCzC+2FYJ2f2VjaGbrYRlONgcJSCAViT1c/CJ3qZLK+72jiMDBnwoOIY8HbR8Vqq9a/L7euwXyiMAalbMXLH9aO3kVTr2SEmTtF0e3l9Unc/t+V1ao+OFNPrOI9w1sSisUx9tB8A1HsRW0/yUeLi009fHoo5F74V4s7ge4ETW5mwrvAuPpvOY6crJIrlZTfb2M30/2/6/b5QQDaYISE9y3xA==\",

\"usuario\": \"testUser\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[

{

\"clave\": \"\",

\"valor\": \"\"

}

\]

},

\"dinBody\": null,

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T12:43:27.639ECT\",

\"origen\": \"MS\",

\"codigo\": \"0003\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"El valor del campo codigoTransaccion es requerido.\",

\"detalle\": \"\"

}

}

### Validar OTP:

Este servicio valida la OTP ingresada por el cliente y determina si se autoriza o rechaza el consumo, notificando al cliente en caso de fallo.

*Method: POST*

*Content-Type: application/json*

**Entrada:**

<table>
<colgroup>
<col style="width: 18%" />
<col style="width: 9%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 15%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td><p><strong>Cabecera estándar de</strong></p>
<p><strong>mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>perfil</strong></td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El perfil del cliente</td>
<td><p>Valores posibles: S=Natural</p>
<p>E=Juridico</p></td>
</tr>
<tr class="even">
<td><strong>usuarioBiometricoEncri ptado</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Opcional</td>
<td><p>El usuario biométrico encriptado del cliente.</p>
<p>La longitud máxima del valor en claro</p>
<p>es 16.</p></td>
<td><p>Ejemplo: QuJyRk8yA2QBW4dZaBt aKw==</p>
<p>Ejemplo de valor en claro: juanPerez80</p></td>
</tr>
<tr class="odd">
<td><strong>codigoTransaccion</strong></td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El código de transacción</td>
<td><p>Ejemplo:</p>
<p>PTP= Place To Pay</p></td>
</tr>
<tr class="even">
<td><strong>codigoOTPEncriptado</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td><p>Código OTP Encriptado.</p>
<p>La longitud</p>
<p>del valor en claro es 6.</p></td>
<td><p>Ejemplo: RE5P5eRqeYaNvPszdsS Gng==</p>
<p>Ejemplo de valor en claro:</p>
<p>123456</p></td>
</tr>
<tr class="odd">
<td><strong>tarjetaEncriptada</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td><p>Tarjeta encriptada .</p>
<p>La longitud máxima del</p>
<p>valor en claro es 22.</p></td>
<td>Ejemplo: Pnr2TclSjqqQtKTvS85p6 Q==</td>
</tr>
<tr class="even">
<td><strong>tipoTarjeta</strong></td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>Tipo tarjeta</td>
<td><p>Valores posibles:</p>
<p>C=Crédito D=Débito</p></td>
</tr>
<tr class="odd">
<td><strong>parametrosAdicionales</strong></td>
<td>Lista</td>
<td></td>
<td></td>
<td></td>
<td>Opcional</td>
<td>La lista de parámetros adicionales</td>
<td></td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 13%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th colspan="8"><strong>Estructura ParámetrosAdicionales</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>Campo</strong></td>
<td><strong>Tipo</strong></td>
<td><strong>Long. entera</strong></td>
<td><strong>Long. decimal</strong></td>
<td><strong>Formato</strong></td>
<td><strong>Mandato</strong></td>
<td><strong>Descripción</strong></td>
<td><strong>Valor</strong></td>
</tr>
<tr class="even">
<td><strong>clave</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>La clave del parámetro</td>
<td><p>Ejemplo:</p>
<p>Param_Adicional_1</p></td>
</tr>
<tr class="odd">
<td><strong>valor</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>El valor del parámetro</td>
<td><p>Ejemplo:</p>
<p>1231</p></td>
</tr>
<tr class="even">
<td><strong>tipo</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>El tipo de dato del parámetro</td>
<td><p>Valores posibles: STRING=Texto INT=Entero BOOLEAN=Booleano</p>
<p>DECIMAL=Decimal</p></td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><blockquote>
<p><strong>Valor</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>Cabecera estándar de</strong></p>
<p><strong>mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>respuestaSolicitud</strong></td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>El código de respuesta</td>
<td><p>Posibles valores:</p>
<p>0=OTP correcto 56=OTP incorrecto 57=OTP Cta. bloqueada 61=OTP expirado</p>
<p>903=OTP no generado</p></td>
</tr>
<tr class="even">
<td><strong>DinError *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>DinError estándar de</strong></p>
<p><strong>respuesta</strong></p></td>
<td></td>
</tr>
</tbody>
</table>

**Mensajes de error:**

  -------------------------------------------------------------------------------
  **Código Error**   **Descripción**
  ------------------ ------------------------------------------------------------
  0001               El valor del campo perfil es requerido

  0002               La longitud del valor perfil es mayor a 1

  0003               El valor del campo codigoTransaccion es requerido

  0004               La longitud del valor codigoTransaccion es mayor a 3

  0005               El valor del campo codigoOTPEncriptado es requerido

  0006               El valor del campo tarjetaEncriptada es requerido

  0007               El valor del campo tipoTarjeta es requerido

  0008               La longitud del valor tipoTarjeta es mayor a 1

  9994               Tarjeta no encontrada

  9995               El AplicacionId es Requerido

  9996               El CanalId es Requerido

  9997               Error en el Descifrado de datos

  9998               Error en el cifrado de datos

  9999               Error en criptografía

  0010               El campo perfil no cumple con la expresión requerida S o E
  -------------------------------------------------------------------------------

**Ejemplo de request (Caso exitoso):**

{

    \"dinHeader\": {

        \"aplicacionId\": \"PTP\",

        \"canalId\": \"IN\",

        \"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

        \"dispositivo\": \"\",

        \"idioma\": \"\",

        \"portalId\": \"\",

        \"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

        \"ip\": \"127.0.0.1\",

        \"horaTransaccion\": \"2024-12-31T16:31:38.001\",

        \"llaveSimetrica\": \"Fe-zUwpyqmHupVj02KU+8vH/zkW39ojmZY+O8gNHko/91TNY4V/tHMde4G6NqI73U1F KnF0OEGZ7ciSF1w0Em1NTMXaAcr8SBo-wYITLrhb/ht5CC2HzV8RLsP+GPRO4Qz49PHlPopuksNS- VfAQ7Vw8I4DhtxZUUShGSPoD-KKNCFuyj2+NgnjneOiauShG1H6ZGjM7GNdR7f56bcGNV3vv3UsJrVm/H1iQFya0XT 6+xVVcxAyOYeW4b0SGm9ra8uzklZ0ZxNNP5+4sP9wWBAUF+9wffMA- vouJcZl8bZRUDGjjsB/J9z1auu0WFqRxK586ZFKafLJhbaY5/9AcWVZT9Ng==\",

        \"usuario\": \"\",

        \"paginado\": {

            \"cantRegistros\": 0,

            \"numTotalPag\": 0,

            \"numPagActual\": 0

        },

        \"tags\": \[\]

    },

    \"dinBody\": {

        \"perfil\": \"S\",

        \"usuarioBiometricoEncriptado\": \"\",

        \"codigoTransaccion\": \"PTP\",

        \"codigoOTPEncriptado\": \"6BSFEJTcWwtGrHqTJ5AyzQ==\",

        \"tarjetaEncriptada\": \"DVYmVxfLrqDQey7vPdHcYw==\",

        \"tipoTarjeta\": \"C\",

        \"parametrosAdicionales\": \[\]

    }

}

**Respuesta**

{

    \"dinHeader\": {

        \"aplicacionId\": \"PTP\",

        \"canalId\": \"IN\",

        \"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

        \"dispositivo\": \"\",

        \"idioma\": \"\",

        \"portalId\": \"\",

        \"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

        \"ip\": \"127.0.0.1\",

        \"horaTransaccion\": \"2024-12-31T16:31:38.001\",

        \"llaveSimetrica\": \"Fe-zUwpyqmHupVj02KU+8vH/zkW39ojmZY+O8gNHko/91TNY4V/tHMde4G6NqI73U1F KnF0OEGZ7ciSF1w0Em1NTMXaAcr8SBo-wYITLrhb/ht5CC2HzV8RLsP+GPRO4Qz49PHlPopuksNS- VfAQ7Vw8I4DhtxZUUShGSPoD-KKNCFuyj2+NgnjneOiauShG1H6ZGjM7GNdR7f56bcGNV3vv3UsJrVm/H1iQFya0XT 6+xVVcxAyOYeW4b0SGm9ra8uzklZ0ZxNNP5+4sP9wWBAUF+9wffMA- vouJcZl8bZRUDGjjsB/J9z1auu0WFqRxK586ZFKafLJhbaY5/9AcWVZT9Ng==\",

        \"usuario\": \"\",

        \"paginado\": {

            \"cantRegistros\": 0,

            \"numTotalPag\": 0,

            \"numPagActual\": 0

        },

        \"tags\": \[\]

    },

    \"dinBody\": {

        \"respuestaSolicitud\": \"0\"

    },

    \"dinError\": {

        \"tipo\": \"N\",

        \"fecha\": \"2024-04-17T22:30:16.355GMT\",

        \"origen\": **null**,

        \"codigo\": \"0000\",

        \"codigoErrorProveedor\": **null**,

        \"mensaje\": \"OK\",

        \"detalle\": \"OK\"

    }

}

**Ejemplo de request (Caso fallido):**

{

    \"dinHeader\": {

        \"aplicacionId\": \"PTP\",

        \"canalId\": \"IN\",

        \"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

        \"dispositivo\": \"\",

        \"idioma\": \"\",

        \"portalId\": \"\",

        \"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

        \"ip\": \"127.0.0.1\",

        \"horaTransaccion\": \"2024-12-31T16:31:38.001\",

        \"llaveSimetrica\": \"Fe-zUwpyqmHupVj02KU+8vH/zkW39ojmZY+O8gNHko/91TNY4V/tHMde4G6NqI73U1F KnF0OEGZ7ciSF1w0Em1NTMXaAcr8SBo-wYITLrhb/ht5CC2HzV8RLsP+GPRO4Qz49PHlPopuksNS- VfAQ7Vw8I4DhtxZUUShGSPoD-KKNCFuyj2+NgnjneOiauShG1H6ZGjM7GNdR7f56bcGNV3vv3UsJrVm/H1iQFya0XT 6+xVVcxAyOYeW4b0SGm9ra8uzklZ0ZxNNP5+4sP9wWBAUF+9wffMA- vouJcZl8bZRUDGjjsB/J9z1auu0WFqRxK586ZFKafLJhbaY5/9AcWVZT9Ng==\",

        \"usuario\": \"\",

        \"paginado\": {

            \"cantRegistros\": 0,

            \"numTotalPag\": 0,

            \"numPagActual\": 0

        },

        \"tags\": \[\]

    },

    \"dinBody\": {

        \"perfil\": \"S\",

        \"usuarioBiometricoEncriptado\": \"\",

        \"codigoTransaccion\": \"PTP\",

        \"codigoOTPEncriptado\": \"\",

        \"tarjetaEncriptada\": \"DVYmVxfLrqDQey7vPdHcYw==\",

        \"tipoTarjeta\": \"C\",

        \"parametrosAdicionales\": \[\]

    }

}

**Respuesta**

{

    \"dinHeader\": {

        \"aplicacionId\": \"PTP\",

        \"canalId\": \"IN\",

        \"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

        \"dispositivo\": \"\",

        \"idioma\": \"\",

        \"portalId\": \"\",

        \"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

        \"ip\": \"127.0.0.1\",

        \"horaTransaccion\": \"2024-12-31T16:31:38.001\",

        \"llaveSimetrica\": \"Fe-zUwpyqmHupVj02KU+8vH/zkW39ojmZY+O8gNHko/91TNY4V/tHMde4G6NqI73U1F KnF0OEGZ7ciSF1w0Em1NTMXaAcr8SBo-wYITLrhb/ht5CC2HzV8RLsP+GPRO4Qz49PHlPopuksNS- VfAQ7Vw8I4DhtxZUUShGSPoD-KKNCFuyj2+NgnjneOiauShG1H6ZGjM7GNdR7f56bcGNV3vv3UsJrVm/H1iQFya0XT 6+xVVcxAyOYeW4b0SGm9ra8uzklZ0ZxNNP5+4sP9wWBAUF+9wffMA- vouJcZl8bZRUDGjjsB/J9z1auu0WFqRxK586ZFKafLJhbaY5/9AcWVZT9Ng==\",

        \"usuario\": \"\",

        \"paginado\": {

            \"cantRegistros\": 0,

            \"numTotalPag\": 0,

            \"numPagActual\": 0

        },

        \"tags\": \[\]

    },

    \"dinBody\": **null**,

    \"dinError\": {

        \"tipo\": \"N\",

        \"fecha\": \"2024-04-18T13:48:25.399GMT\",

        \"origen\": \"MS\",

        \"codigo\": \"0006\",

        \"codigoErrorProveedor\": **null**,

        \"mensaje\": \"El campo codigoOTP es requerido\",

        \"detalle\": \"\"

    }

}

### Consultar tipos de crédito:

Este servicio consulta los tipos de crédito o formas de pago disponibles para un comercio y una tarjeta específicos, permitiendo su posterior selección por parte del cliente.

*Method: POST*

*Content-Type: application/json*

**Entrada:**

<table>
<colgroup>
<col style="width: 18%" />
<col style="width: 9%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 15%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td><p><strong>Cabecera estándar de</strong></p>
<p><strong>mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>codigoComercio</strong></td>
<td>String</td>
<td>10</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El código de comercio</td>
<td>1401456</td>
</tr>
<tr class="even">
<td><strong>tarjetaEncriptada</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td>El número de tarjeta encriptado.</td>
<td><p>s+YMmoxpfGL</p>
<p>OSzUgVqyPO A==</p></td>
</tr>
<tr class="odd">
<td><strong>tarjetaEnmascarada</strong></td>
<td>String</td>
<td>22</td>
<td></td>
<td></td>
<td>Opcional</td>
<td>El número de tarjeta enmascarado.</td>
<td><p>3608XXXXXX1</p>
<p>401</p></td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><blockquote>
<p><strong>Valor</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>Cabecera estándar de</strong></p>
<p><strong>mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>numeroRegistros</strong></td>
<td>Integer</td>
<td>4</td>
<td></td>
<td></td>
<td>Variable</td>
<td><p>El número de</p>
<p>registros encontrados</p></td>
<td><p>Ejemplo:</p>
<p>23</p></td>
</tr>
<tr class="even">
<td><strong>formasDePago</strong></td>
<td><strong>Lista</strong></td>
<td></td>
<td></td>
<td></td>
<td>Variable</td>
<td>Lista de formas de pago</td>
<td></td>
</tr>
<tr class="odd">
<td><blockquote>
<p><strong>idMatriz</strong></p>
</blockquote></td>
<td>Integer</td>
<td>4</td>
<td></td>
<td></td>
<td>Variable</td>
<td>El identificador de matriz</td>
<td><p>Ejemplo:</p>
<p>1</p></td>
</tr>
<tr class="even">
<td><blockquote>
<p><strong>codigoGrupoTipoCredito</strong></p>
</blockquote></td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Variable</td>
<td>El código del grupo de tipo de crédito</td>
<td>Valores posibles: C=CORRIENTE P=DIFERIDO PROPIO X=PLAN PAGOS ESPECIAL</td>
</tr>
<tr class="odd">
<td><blockquote>
<p><strong>tipoCredito</strong></p>
</blockquote></td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td>Variable</td>
<td>El tipo de crédito</td>
<td><p>Ejemplos: 00=CORRIENTE</p>
<p>02=DIFERIDO PROPIO 03=PLAN PAGOS ESPECIAL</p></td>
</tr>
<tr class="even">
<td><blockquote>
<p><strong>descripcionGrupoTipoCredito</strong></p>
</blockquote></td>
<td>String</td>
<td>20</td>
<td></td>
<td></td>
<td>Variable</td>
<td>La descripción del grupo</td>
<td>Ejemplo: DIFERIDO PROPIO</td>
</tr>
<tr class="odd">
<td><blockquote>
<p><strong>cuotas</strong></p>
</blockquote></td>
<td>Integer</td>
<td>3</td>
<td></td>
<td></td>
<td>Variable</td>
<td>El número de cuotas</td>
<td>Ejemplo: 12</td>
</tr>
<tr class="even">
<td><strong>DinError *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>DinError</strong></p>
<p><strong>estándar de respuesta</strong></p></td>
<td></td>
</tr>
</tbody>
</table>

**Mensajes de error:**

  -----------------------------------------------------------------------------------------------------------
  **Código Error**   **Descripción**
  ------------------ ----------------------------------------------------------------------------------------
  10                 CAPA DE NEGOCIO

  IIB-XXX            ERRORES DE COMUNICACIÓN (TimeOuts) O ESTRUCTURA

  9997               Error en el Descifrado de datos AES256

  9998               Error en el cifrado de datos AES256

  9995               El ApplicationId es obligatorio

  9996               El CanalId es obligatorio

  9999               Obtener llave privada

  0018               El campo codigoComercio es obligatorio

  0019               El campo tarjetaEncriptada es obligatorio

  0020               La longitud del campo codigoComercio sobrepasa la longitud máxima de 10 caracteres

  0021               La longitud del campo tarjetaEnmascarada sobrepasa la longitud máxima de 22 caracteres
  -----------------------------------------------------------------------------------------------------------

**Ejemplo de request (Caso exitoso):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"fecha\": \"20290222\",

\"hora\": \"165750\",

\"montoTransaccion\": \"200\",

\"codigoComercio\": 1401456,

\"idMatriz\": 1,

\"codigoGrupoTipoCredito\": \"P\",

\"tipoCredito\": \"02\",

\"cuotas\": 3,

\"tarjetaEncriptada\": \"md3Ovx9xLv++13qwpksrlmO+EvI4sq8hkhfdqC2naPKzykLi3jMH5hDSaPk=\",

\"tarjetaEnmascarada\": \"3640-XXX-XXXX-2208\"

}

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"numeroRegistros\": 18,

\"formasDePago\": \[

{

\"idMatriz\": 1,

\"codigoGrupoTipoCredito\": \"C\",

\"tipoCredito\": \"00\",

\"descripcionGrupoTipoCredito\": \"Corriente\",

\"cuotas\": 1

},

{

\"idMatriz\": 1,

\"codigoGrupoTipoCredito\": \"P\",

\"tipoCredito\": \"02\",

\"descripcionGrupoTipoCredito\": \"Diferido Propio\",

\"cuotas\": 50

}

\]

},

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T14:11:50.483ECT\",

\"origen\": null,

\"codigo\": \"0000\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"OK\",

\"detalle\": \"OK\"

}

}

**Ejemplo de request (Caso fallido):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"fecha\": \"20290222\",

\"hora\": \"165750\",

\"montoTransaccion\": \"200\",

\"codigoComercio\": 1401456,

\"idMatriz\": 1,

\"codigoGrupoTipoCredito\": \"P\",

\"tipoCredito\": \"02\",

\"cuotas\": 3,

\"tarjetaEncriptada\": \"md3Ovx9xLv++13qwpksrlmO+EvI4sq8hkhfdqC2naPKzykLi3jMH5hDSaPk=\",

\"tarjetaEnmascarada\": \"3640-XXX-XXXX-2208-99999\"

}

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": null,

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T14:13:24.636ECT\",

\"origen\": \"MS\",

\"codigo\": \"0021\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"La longitud del campo tarjetaEnmascarada sobrepasa la longitud máxima de 22 caracteres\",

\"detalle\": \"\"

}

}

### Cálcular interés:

Este servicio calcula los intereses, la cuota y el total con intereses en función del comercio, la tarjeta y el tipo de crédito.

*Method: POST*

*Content-Type: application/json*

**Entrada:**

<table>
<colgroup>
<col style="width: 21%" />
<col style="width: 10%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td><strong>Cabecera estándar de mensaje</strong></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>fecha</strong></td>
<td>String</td>
<td>8</td>
<td></td>
<td>AAAAMM DD</td>
<td>Obligatorio</td>
<td>La fecha de la transacción</td>
<td>20290222</td>
</tr>
<tr class="even">
<td><strong>hora</strong></td>
<td>String</td>
<td>6</td>
<td></td>
<td>HHMMSS</td>
<td>Obligatorio</td>
<td>La hora de la transacción</td>
<td>165750</td>
</tr>
<tr class="odd">
<td><strong>montoTransaccion</strong></td>
<td>String</td>
<td>9</td>
<td>2</td>
<td></td>
<td><p>Obligatorio</p>
<p>Sin separador de miles ni decimales. Las 2 últimas posiciones son decimales</p></td>
<td>El monto de la transacción</td>
<td><p>Ejemplo:</p>
<p>Para enviar 103.12 se debe enviar 10312</p></td>
</tr>
<tr class="even">
<td><strong>codigoComercio</strong></td>
<td>Integer</td>
<td>10</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El código del comercio</td>
<td><p>Ejemplo:</p>
<p>1375551</p></td>
</tr>
<tr class="odd">
<td><strong>idMatriz</strong></td>
<td>Integer</td>
<td>4</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El identificador de la matriz</td>
<td><p>Ejemplo:</p>
<p>1</p></td>
</tr>
<tr class="even">
<td><strong>codigoGrupoTipoCredito</strong></td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El código del grupo de tipo de crédito</td>
<td><p>Valores posibles: C=CORRIENTE</p>
<p>P=DIFERIDO PROPIO X=PLAN PAGOS ESPECIAL</p></td>
</tr>
<tr class="odd">
<td><strong>tipoCredito</strong></td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El tipo de crédito</td>
<td><p>Ejemplos: 00=CORRIENTE</p>
<p>02=DIFERIDO PROPIO</p>
<p>03=PLAN PAGOS</p>
<p>ESPECIAL</p></td>
</tr>
<tr class="even">
<td><strong>cuotas</strong></td>
<td>Integer</td>
<td>3</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>El número de cuotas</td>
<td><p>Ejemplo:</p>
<p>12</p></td>
</tr>
<tr class="odd">
<td><strong>tarjetaEncriptada</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td><p>El número de tarjeta</p>
<p>encriptado</p></td>
<td>rKyhObVF0J7qFE9w Ak9p7A==</td>
</tr>
<tr class="even">
<td><strong>tarjetaEnmascarada</strong></td>
<td>String</td>
<td>22</td>
<td></td>
<td></td>
<td>Opcional</td>
<td><p>El número de</p>
<p>tarjeta enmascarado</p></td>
<td>3608XXXXXX1401</td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><blockquote>
<p><strong>Valor</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>Cabecera estándar de</strong></p>
<p><strong>mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><strong>fecha</strong></td>
<td>String</td>
<td>8</td>
<td></td>
<td>AAAA- MM-DD</td>
<td>Variable</td>
<td>La fecha de la transacción</td>
<td><p>Ejemplo:</p>
<p>20290222</p></td>
</tr>
<tr class="even">
<td><strong>hora</strong></td>
<td>String</td>
<td>6</td>
<td></td>
<td>HH-MM- SS</td>
<td>Variable</td>
<td>La hora de la transacción</td>
<td>Ejemplo: 165750</td>
</tr>
<tr class="odd">
<td><strong>tarjetaEncriptada</strong></td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Variable</td>
<td>El número de tarjeta encriptado</td>
<td><p>Ejemplo: rKyhObVF0J7qFE9w</p>
<p>Ak9p7A==</p></td>
</tr>
<tr class="even">
<td><strong>montoTransaccio n</strong></td>
<td>String</td>
<td>9</td>
<td>2</td>
<td><p>Sin separador de miles ni decimales.</p>
<p>Las 2 últimas posiciones son decimales</p></td>
<td>Variable</td>
<td>El monto de la transacción</td>
<td><p>Ejemplo:</p>
<p>Para enviar 103.12 se debe envía 10312</p></td>
</tr>
<tr class="odd">
<td><strong>valorCuota</strong></td>
<td>String</td>
<td>9</td>
<td>2</td>
<td><p>Sin separador de miles ni decimales.</p>
<p>Las 2 últimas posiciones son decimales</p></td>
<td>Variable</td>
<td>El valor de las cuotas</td>
<td><p>Ejemplo:</p>
<p>Para enviar 103.12 se debe enviar 10312</p></td>
</tr>
<tr class="even">
<td><strong>montoInteres</strong></td>
<td>String</td>
<td>9</td>
<td>2</td>
<td><p>Sin separador de miles ni decimales.</p>
<p>Las 2 últimas posiciones son decimales</p></td>
<td>Variable</td>
<td>El monto del interes calculado</td>
<td><p>Ejemplo:</p>
<p>Para enviar 103.12 se debe enviar 10312</p></td>
</tr>
<tr class="odd">
<td><strong>montoTotal</strong></td>
<td>String</td>
<td>9</td>
<td>2</td>
<td><p>Sin separador de miles ni decimales.</p>
<p>Las 2 últimas posiciones son decimales</p></td>
<td>Variable</td>
<td>El monto total</td>
<td><p>Ejemplo:</p>
<p>Para enviar 103.12 se debe enviar 10312</p></td>
</tr>
<tr class="even">
<td><strong>DinError *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><p><strong>DinError estándar de</strong></p>
<p><strong>respuesta</strong></p></td>
<td></td>
</tr>
</tbody>
</table>

**Mensajes de error:**

  --------------------------------------------------------------------------------------------------------------
  **Código Error**   **Descripción**
  ------------------ -------------------------------------------------------------------------------------------
  10                 CAPA NEGOCIO

  IIB-XXX            ERRORES DE COMUNICACIÓN (TimeOuts) O ESTRUCTURA

  9997               Error en el Descifrado de datos AES256

  9998               Error en el cifrado de datos AES256

  9995               El ApplicationId es obligatorio

  9996               El CanalId es obligatorio

  9999               Obtener llave privada

  0001               El campo fecha es obligatorio

  0002               El campo hora es obligatorio

  0003               El campo montoTransaccion es obligatorio

  0004               El campo codigoComercio es obligatorio

  0005               El campo idMatriz es obligatorio

  0006               El campo codigoGrupoTipoCredito es obligatorio

  0007               El campo tipoCredito es obligatorio

  0008               El campo cuotas es obligatorio

  0009               El campo tarjetaEncriptada es obligatorio

  0010               La longitud del campo fecha sobrepasa la longitud máxima de 8 caracteres

  0011               La longitud del campo hora sobrepasa la longitud máxima de 6 caracteres

  0012               La longitud del campo montoTransaccion sobrepasa la longitud máxima de 11 caracteres

  0013               La longitud del campo codigoComercio sobrepasa la longitud máxima de 10 caracteres

  0014               La longitud del campo idMatriz sobrepasa la longitud máxima de 4 caracteres

  0015               La longitud del campo codigoGrupoTipoCredito sobrepasa la longitud máxima de 1 caracteres

  0016               La longitud del campo tipoCreditosobrepasa la longitud máxima de 3 caracteres

  0017               La longitud del campo tarjetaEnmascarada sobrepasa la longitud máxima de 22 caracteres

  0018               Fecha debe tener el formato AAAAMMDD

  0019               Hora debe tener el formato HHMMSS

  0020               El campo montoTransaccion maneja solamente datos numericos
  --------------------------------------------------------------------------------------------------------------

**Ejemplo de request (Caso exitoso):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"TBkGsuutsf3WN9PCXlxUkoxDH5sNv4y6odaYCL7gCoVIvORKjD9kEl/LwUb8khLNQHisU9OvDtyv1kMMCTHBKdwCQmiYSGznFjSjjROzz58pt1ypeTQe3t/CI0x1uRl5QGkTlGAN7lXkOLxacMfV2KJzOqffFP4yu2xhntQas0HutFCSIpw+l+l8DtmS0ACFVqEajvt/D+7VvfvgOxBG2OgKz66xRAiIrykGB3rXIBFtsjSHD8B3tLJ+Nj6lG6jjtOyhV572mtHIuZ9ywwQ2hoW6+/6yWW+UYC47yNWiGDd5TcHAy2r31GeSAW0yJTNx2XsPYpMRY6B1fxQexKncBQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"fecha\": \"20290222\",

\"hora\": \"165750\",

\"montoTransaccion\": \"200\",

\"codigoComercio\": 1375551,

\"idMatriz\": 1,

\"codigoGrupoTipoCredito\": \"P\",

\"tipoCredito\": 1,

\"cuotas\": 1,

\"tarjetaEncriptada\": \"f2Uw7ywlbUBLs68THye8fwlXaDDOVQQCiXeR0q9MPWDrv3oDnCMJOLKN\",

\"tarjetaEnmascarada\": \"3640-XXX-XXXX-2208\"

}

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"fZeIk0UNtiPmzX1Ggjztsul5iR0fJusNTEceBShKnyrqNWmvp4gGMLcQwjXINpSjAi6UjcHDP6ThQ3UZ933GiGaT9io62EuS36y8PAKgcMF1NW/HkpsaCdhomA9ylGI2cgTctxr5abKQlWeqNBMiFtVj3579WEGfnQ96jTY6Azsdbakv+D2mrKfRMaqbJohBu6ADMl0mDSuA6Fjya9Jk+ZLwxNQV6bbIl9Ohnbeit7TwnGr40XzIotatn6uImTai4F7oA8ORRSYVzCzwF50dqNCjt2n+SQLwct9ycSkLcCU0M46anuQ02I7eRb8QtHxwHQo8eZSQTVo8LmuvyJhFTA==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"fecha\": \"20290222\",

\"hora\": \"165750\",

\"tarjetaEncriptada\": \"A5cbFx8vmMHbLp7cKpQSh2s7D5D1JE8jgxF1UjZDJ6qZ6T0I6/dLsoit\",

\"montoTransaccion\": \"200\",

\"valorCuota\": \"200\",

\"montoInteres\": \"0\",

\"montoTotal\": \"200\"

},

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T14:50:13.800ECT\",

\"origen\": null,

\"codigo\": \"0000\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"OK\",

\"detalle\": \"OK\"

}

}

**Ejemplo de request (Caso fallido):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": {

\"fecha\": \"20290222\",

\"hora\": \"165750\",

\"montoTransaccion\": \"200\",

\"codigoComercio\": 1213760,

\"idMatriz\": 1,

\"codigoGrupoTipoCredito\": \"P\",

\"tipoCredito\": \"02\",

\"cuotas\": 3,

\"tarjetaEncriptada\": \"md3Ovx9xLv++13qwpksrlmO+EvI4sq8hkhfdqC2naPKzykLi3jMH5hDSaPk=\",

\"tarjetaEnmascarada\": \"3640-XXX-XXXX-2208\"

}

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \"8b97a6b0-3d76-4c86-a9ee-9199247df244\",

\"dispositivo\": \"\",

\"idioma\": \"\",

\"portalId\": \"\",

\"uuid\": \"5c37f89a-23bf-412d-8d19-2a1980c85c6e\",

\"ip\": \"127.0.0.1\",

\"horaTransaccion\": \"2024-12-31T16:31:38.001\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \"\",

\"paginado\": {

\"cantRegistros\": 0,

\"numTotalPag\": 0,

\"numPagActual\": 0

},

\"tags\": \[\]

},

\"dinBody\": null,

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T14:40:53.381ECT\",

\"origen\": null,

\"codigo\": \"609\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"Transaccion no permitida en comercio\",

\"detalle\": \"\"

}

}

### Autorización de consumo

Este servicio autoriza o rechaza el consumo en el comercio basado en la tarjeta, el monto, el tipo de crédito y otros datos de entrada proporcionados.

*Method: POST*

*Content-Type: application/json*

**Entrada:**

<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 6%" />
<col style="width: 13%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td><p><strong>Cabecera</strong></p>
<p><strong>estándar de mensaje</strong></p></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>codigoRuteo</td>
<td>String</td>
<td>1</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td><p>Parámetro de control si la transacción</p>
<p>es por ruteo o no</p></td>
<td><p>Valores posibles: R=Transacción con ruteo</p>
<p>T=Transacción sin ruteo</p></td>
</tr>
<tr class="even">
<td>mensajeId</td>
<td>String</td>
<td>4</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>Identificación del Mensaje</td>
<td></td>
</tr>
<tr class="odd">
<td>codigoTipoVia</td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td><p>Código de tipo de vía, Valor fijo parametrizado por Diners para ChatBot: 42</p>
<p>P2P: 40</p></td>
<td><p>0200</p>
<p>Código de vía (47 Full Carga)</p></td>
</tr>
<tr class="even">
<td>numeroTarjeta</td>
<td>String</td>
<td>40</td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td>Número de cuenta. Número de tarjeta si no es leída o es T.I.</td>
<td><p>Tarjeta encriptada</p>
<p>scAfRUHCY40EuMehJiglKA==</p></td>
</tr>
<tr class="odd">
<td>codigoTransaccion</td>
<td>String</td>
<td>6</td>
<td></td>
<td></td>
<td></td>
<td>Código Transacción.</td>
<td>003000</td>
</tr>
<tr class="even">
<td>montoTransaccion</td>
<td>String</td>
<td>12</td>
<td></td>
<td></td>
<td></td>
<td>Monto total de la transacción. Ejemplo: 0000000000100 es 100$</td>
<td>10000</td>
</tr>
<tr class="odd">
<td>fechaHoraTransmision</td>
<td>String</td>
<td>10</td>
<td></td>
<td></td>
<td></td>
<td>Fecha de Transmisión. Formato: MMDDhhmmss</td>
<td>0410161459</td>
</tr>
<tr class="even">
<td>numeroSeguimientoAuditoria</td>
<td>String</td>
<td>6</td>
<td></td>
<td></td>
<td></td>
<td><p>Traza o Referencia</p>
<p>Número de seguimiento de auditoría de la transacción. Secuencial generado por P2P</p></td>
<td>445749</td>
</tr>
<tr class="odd">
<td>horaTransaccion</td>
<td>String</td>
<td>6</td>
<td></td>
<td></td>
<td></td>
<td>Hora de Transacción local. Formato: Hhmmss</td>
<td>161459</td>
</tr>
<tr class="even">
<td>fechaTransaccion</td>
<td>String</td>
<td>4</td>
<td></td>
<td></td>
<td></td>
<td>Fecha de Transacción local. Formato: MMDD</td>
<td>0410</td>
</tr>
<tr class="odd">
<td>fechaExpiracion</td>
<td>String</td>
<td>4</td>
<td></td>
<td></td>
<td></td>
<td>Fecha de Expiración. Formato: YYMM</td>
<td><p>Encriptada</p>
<p>2eAfRZGAdn0EuijuYglKA==</p></td>
</tr>
<tr class="even">
<td>fechaContable</td>
<td>String</td>
<td>4</td>
<td></td>
<td></td>
<td></td>
<td>Fecha Contable. Formato: MMDD</td>
<td>0130</td>
</tr>
<tr class="odd">
<td>actividadComercial</td>
<td>String</td>
<td>4</td>
<td></td>
<td></td>
<td></td>
<td>Actividad Comercial</td>
<td></td>
</tr>
<tr class="even">
<td>tipoLecturaPOS</td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td></td>
<td>Tipo de lectura POS .</td>
<td></td>
</tr>
<tr class="odd">
<td>secuenciaNumeroTarjeta</td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td></td>
<td>Secuencia del Número de Tarjeta</td>
<td>3</td>
</tr>
<tr class="even">
<td>idDatafast</td>
<td>String</td>
<td>11</td>
<td></td>
<td></td>
<td></td>
<td>Id Datafast | ID Adquirente</td>
<td></td>
</tr>
<tr class="odd">
<td>idEmisor</td>
<td>String</td>
<td>11</td>
<td></td>
<td></td>
<td></td>
<td>Id Único del Emisor.</td>
<td></td>
</tr>
<tr class="even">
<td>track2</td>
<td>String</td>
<td>N/A</td>
<td></td>
<td></td>
<td></td>
<td><p>Track2 leído de la tarjeta.</p>
<p>Encriptado</p></td>
<td>wTwsWYoQ2upI6f/JlPie1hOaO+kqQ83AxbeEGSOPQ+sJ4UJTDr4qLZEt0BzSMHUY</td>
</tr>
<tr class="odd">
<td>numeroReferenciaTransaccion</td>
<td>String</td>
<td>12</td>
<td></td>
<td></td>
<td></td>
<td>Número de Referencia Transacción.</td>
<td>500616010814<br />
999999164023</td>
</tr>
<tr class="even">
<td>numeroAprobacion</td>
<td>String</td>
<td>6</td>
<td></td>
<td></td>
<td></td>
<td>Número de Aprobación</td>
<td></td>
</tr>
<tr class="odd">
<td>codigoRespuesta</td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td></td>
<td>Código de Respuesta</td>
<td></td>
</tr>
<tr class="even">
<td>idTerminalEstablecimiento</td>
<td>String</td>
<td>8</td>
<td></td>
<td></td>
<td></td>
<td>Id Terminal Establecimiento</td>
<td></td>
</tr>
<tr class="odd">
<td>idEstablecimiento</td>
<td>String</td>
<td>10</td>
<td></td>
<td></td>
<td></td>
<td>Id Establecimiento</td>
<td><p>990099</p>
<p>H0000096</p></td>
</tr>
<tr class="even">
<td>nombreEstablecimiento</td>
<td>String</td>
<td>40</td>
<td></td>
<td></td>
<td></td>
<td>Nombre del Establecimiento.</td>
<td>SERVICIO DE RENTAS INT UIO 218</td>
</tr>
<tr class="odd">
<td>track1</td>
<td>String</td>
<td>N/A</td>
<td></td>
<td></td>
<td></td>
<td><p>Track1 Leído de la Tarjeta</p>
<p>Encriptado</p></td>
<td>wTwsWYoQ2upI6f/JlPie1hOaO+kqQ83AxbeEGSOPQ+sJ4UJTDr4qLZEt0BzSMHUY</td>
</tr>
<tr class="even">
<td>codigoSeguridad</td>
<td>String</td>
<td>256</td>
<td></td>
<td></td>
<td></td>
<td>Código de Seguridad.</td>
<td><p>R373401110000024659103150012159551<br />
<br />
Contiene los campos dentro de trama.</p>
<p>Subelemento 43 datoSeguridad3DS (3–D Secure for Mastercard Identity Check)</p>
<p>Subelemento 42 indicadorSeguridad3DS (Electronic Commerce Indicators)</p>
<p>Subelemento 66XX idProtocolo3DS</p>
<p>Subelemento 66YY idTransaccionMastercard3DS</p>
<p>Subelement 33 (PAN Mapping File Information)</p>
<p>Subelemneto 44 (Token Authentication Verification Value (TAVV))</p></td>
</tr>
<tr class="odd">
<td>codigoMoneda</td>
<td>String</td>
<td>3</td>
<td></td>
<td></td>
<td></td>
<td>Código de moneda</td>
<td>840</td>
</tr>
<tr class="even">
<td>pinBlock</td>
<td>String</td>
<td>16</td>
<td></td>
<td></td>
<td></td>
<td>PIN BLOCK encryptado</td>
<td></td>
</tr>
<tr class="odd">
<td>tarjetaARecargarEncriptada</td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Tarjeta a recargar encriptada</td>
<td></td>
</tr>
<tr class="even">
<td>montosAdicionales</td>
<td>String</td>
<td>91</td>
<td></td>
<td></td>
<td></td>
<td>Valores (IVA, Propina, Servicio, Intereses, # Autorización, Monto Fijo.</td>
<td><p>Enviado como Trama</p>
<p>161112000000000000</p>
<p>Contiene campos anteriores que se enviaban individualmente.</p>
<p>montoIVA</p>
<p>montoICE</p>
<p>montoPropina</p></td>
</tr>
<tr class="odd">
<td>circuitoIntegradoTarjeta</td>
<td>String</td>
<td>512</td>
<td></td>
<td></td>
<td></td>
<td>Circuito Integrado de la tarjeta. Es un hexadecimal empaquetado.</td>
<td></td>
</tr>
<tr class="even">
<td>informacionProductos</td>
<td>String</td>
<td>256</td>
<td></td>
<td></td>
<td></td>
<td>Información de Productos.</td>
<td><p>Recibido en trama</p>
<p>tipoCredito: 0001<br />
00003001<br />
<br />
DEBERIA SER 00003001 (CORRIENTE: 000;LONGITUD:03; CUOTAS:001)</p></td>
</tr>
<tr class="odd">
<td>valoresAdicionales</td>
<td>String</td>
<td>256</td>
<td></td>
<td></td>
<td></td>
<td>Valores Adicionales.</td>
<td><p>Recibido en trama</p>
<p>valorCampo58</p>
<p>0870205585</p>
<p>CORRESPONDE AL 58.70, DEBERÍA SER 0100870205585</p></td>
</tr>
<tr class="even">
<td>datosPOS</td>
<td>String</td>
<td>256</td>
<td></td>
<td></td>
<td></td>
<td>Datos del POS</td>
<td><p>Recibido en trama</p>
<p>00000000003002180000000000</p>
<p>valorCampo61</p>
<p>Preauth:00000040000002180000000000</p>
<p>COF: 10241000066002180000000000</p></td>
</tr>
<tr class="odd">
<td>codigoAdministracionRedes</td>
<td>String</td>
<td>5</td>
<td></td>
<td></td>
<td></td>
<td>Código Adminstración Redes</td>
<td></td>
</tr>
<tr class="even">
<td>datosOriginales</td>
<td>String</td>
<td>42</td>
<td></td>
<td></td>
<td></td>
<td>Datos Originales para reversos.</td>
<td></td>
</tr>
<tr class="odd">
<td>codigoMensajeSeguridad</td>
<td>String</td>
<td>5</td>
<td></td>
<td></td>
<td></td>
<td>Código Mensaje Seguridad</td>
<td></td>
</tr>
<tr class="even">
<td>tagsAdministracionRedes</td>
<td>String</td>
<td>256</td>
<td></td>
<td></td>
<td></td>
<td>Tags Adminstración Redes</td>
<td></td>
</tr>
<tr class="odd">
<td>tarjetaEnmascarada</td>
<td>String</td>
<td>16</td>
<td></td>
<td></td>
<td></td>
<td>Tarjeta enmascarada</td>
<td>XXXX-XXXX-XXXX-3596</td>
</tr>
<tr class="even">
<td>datosPagosDigitales</td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Digital Payment Data – Tokenizacion</td>
<td>DE 104 (Digital Payment Data)</td>
</tr>
<tr class="odd">
<td>cardVerificationEncripted</td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Cvv encriptado</td>
<td>Cvv encriptado: Pgo07xwUEhcuwzfSRnPSXA==</td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 22%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 8%" />
<col style="width: 13%" />
<col style="width: 24%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Campo</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Long. entera</strong></th>
<th><strong>Long. decimal</strong></th>
<th><strong>Formato</strong></th>
<th><strong>Mandato</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>DinHeader *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td><strong>Cabecera estándar de mensaje</strong></td>
<td></td>
</tr>
<tr class="even">
<td><strong>DinBody *</strong></td>
<td><strong>Estructura</strong></td>
<td><strong>N/A</strong></td>
<td></td>
<td></td>
<td><strong>Fijo</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>numeroTarjeta</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Número de cuenta. Número de tarjeta si no es leída o es T.I.</td>
<td><p>Valores encriptados</p>
<p>NaiUImFWYiVA7IBUTlZM7w==</p></td>
</tr>
<tr class="even">
<td>codigoTransaccion</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Código Transacción.</td>
<td>003000</td>
</tr>
<tr class="odd">
<td>montoTransaccion</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Monto total de la transacción. Ejemplo: 0000000000100 es 100$</td>
<td>1518</td>
</tr>
<tr class="even">
<td>fechaHoraTransmision</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Fecha de Transmisión. Formato: MMDDhhmmss</td>
<td>1117103024</td>
</tr>
<tr class="odd">
<td>numeroSeguimientoAuditoria</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Traza o Referencia</td>
<td>5006</td>
</tr>
<tr class="even">
<td>fechaExpiracion</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Fecha de Expiración. Formato: YYMM</td>
<td><p>Valores encriptados</p>
<p>NaiUImFWYiVJ7IBUTlZM7w==</p></td>
</tr>
<tr class="odd">
<td>fechaContable</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Fecha Contable. Formato: MMDD</td>
<td></td>
</tr>
<tr class="even">
<td>idDatafast</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Id Datafast</td>
<td>00000473293</td>
</tr>
<tr class="odd">
<td>idEmisor</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Id Único del Emisor.</td>
<td>00000473293</td>
</tr>
<tr class="even">
<td>track2</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Track2 leído de la tarjeta. (No T.I)</td>
<td>Valores encriptados</td>
</tr>
<tr class="odd">
<td>numeroReferenciaTransaccion</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Número de Referencia Transacción.</td>
<td>5006</td>
</tr>
<tr class="even">
<td>numeroAprobacion</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Número de Aprobación</td>
<td></td>
</tr>
<tr class="odd">
<td>codigoRespuesta</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Código de Respuesta</td>
<td>02</td>
</tr>
<tr class="even">
<td>idTerminalEstablecimiento</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Id Terminal Establecimiento</td>
<td>00990099</td>
</tr>
<tr class="odd">
<td>idEstablecimiento</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Id Establecimiento</td>
<td>1213760</td>
</tr>
<tr class="even">
<td>nombreEstablecimiento</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Nombre del Establecimiento.</td>
<td>APOYO UNICEF UIO 218</td>
</tr>
<tr class="odd">
<td>codigoMoneda</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Código de moneda</td>
<td>840</td>
</tr>
<tr class="even">
<td>datosSeguridad</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Cryptograma T.I / Working Key</td>
<td></td>
</tr>
<tr class="odd">
<td>informacionProductos</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Circuito Integrado de la tarjeta. Es un hexadecimal empaquetado.</td>
<td></td>
</tr>
<tr class="even">
<td>circuitoIntegradoTarjeta</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Información de Productos.</td>
<td></td>
</tr>
<tr class="odd">
<td>tagsAdminstracionRedes</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Tags administración de redes</td>
<td></td>
</tr>
<tr class="even">
<td>montosAdicionales</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Montos adicionales en formato Trama</td>
<td><p>Enviado como Trama</p>
<p>161112000000000000</p>
<p>Contiene campos anteriores que se enviaban individualmente.</p>
<p>montoIVA</p>
<p>montoICE</p>
<p>montoPropina</p>
<p>montoInteres</p></td>
</tr>
<tr class="odd">
<td>tarjetaEnmascarada</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Tarjeta enmascarada</td>
<td>XXXX-XXXX-XXXX-3596</td>
</tr>
<tr class="even">
<td>valorCampo58</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Banknet Reference Number</td>
<td><p>Enviado en formato Trama</p>
<p>107029411226</p></td>
</tr>
<tr class="odd">
<td>codigoSeguridad</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>Contiene Token Requestor ID. Aplica para MasterCard y Visa</td>
<td>DE 48 Subelemento 33 PAN Mapping File Information</td>
</tr>
<tr class="even">
<td>datosCuentaPago</td>
<td>string</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td><p>Datos de la Cuenta de Pago Tokenizacion y Otras Transacciones.</p>
<p>Contiene información exclusiva de referencia no financiera relacionada con el PAN o token utilizado para iniciar la transacción</p></td>
<td><p>DE 56 (Datos de la Cuenta de Pago)</p>
<p>elemento secundario 01</p></td>
</tr>
</tbody>
</table>

**Mensajes de error:**

  ------------------------------------------------------------------------------------------------
  **Código Error**   **Descripción**
  ------------------ -----------------------------------------------------------------------------
  **14**             CAPA DE NEGOCIO

  **IIB-XXX**        ERRORES DE COMUNICACIÓN (TimeOuts) O ESTRUCTURA

  **0001**           El capo XXXXXX es requerido

  **0002**           El valor del campo XXXXXXX es requerido

  **0003**           La longitud del campo XXXXXXX sobrepasa la longitud máxima de XX caracteres
  ------------------------------------------------------------------------------------------------

**Ejemplo de request:**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \" \",

\"dispositivo\": \" \",

\"idioma\": \" \",

\"portalId\": \"PBN\",

\"uuid\": \"1623474121595947:B6AE4261BD4594A746DF1FF9CECF85A32BCADCA1\",

\"ip\": \"200.115.33.10\",

\"horaTransaccion\": \"0220224723\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \" \",

\"paginado\": {

\"cantRegistros\": 10,

\"numTotalPag\": 1,

\"numPagActual\": 1

},

\"tags\": null

},

\"dinBody\": {

\"codigoRuteo\": \"T\",

\"mensajeId\": \"0200\",

\"codigoTipoVia\": \"40\",

\"numeroTarjeta\": \"md3Ovx9xLv++13qwpksrlmO+EvI4sq8hkhfdqC2naPKzykLi3jMH5hDSaPk=\",

\"codigoTransaccion\": \"003000\",

\"montoTransaccion\": \"000000002800\",

\"fechaHoraTransmision\": \"0220224723\",

\"numeroSeguimientoAuditoria\": \"000486\",

\"horaTransaccion\": \"224723\",

\"fechaTransaccion\": \"0220\",

\"fechaExpiracion\": \"DNHhWT5y6NmjpuHRsrwAyqtEO0JhIrWabWKbu/lykXg=\",

\"actividadComercial\": \"5122\",

\"tipoLecturaPOS\": \"010\",

\"secuenciaNumeroTarjeta\": \"001\",

\"idDatafast\": \"01791219058\",

\"idEmisor\": \"00000369696\",

\"track2\": \"\",

\"numeroReferenciaTransaccion\": \"505122020486\",

\"numeroAprobacion\": \"14\",

\"codigoRespuesta\": \"00\",

\"idTerminalEstablecimiento\": \"H0000095\",

\"idEstablecimiento\": \"0001215955\",

\"nombreEstablecimiento\": \"BDO\*MPOSCAL3SALUD Quito ECU\",

\"track1\": \"\",

\"codigoSeguridad\": \"RdS9+KCzcZj5CMH59GxPTgULiOla1ck9GEyxjQTrTg==\",

\"codigoMoneda\": \"840\",

\"pinBlock\": \"\",

\"montosAdicionales\": \"20\",

\"circuitoIntegradoTarjeta\": \"\",

\"informacionProductos\": \"00003001\",

\"valoresAdicionales\": \"053128209984509043783Linea 342 \",

\"datosPOS\": \"00\",

\"codigoAdministracionRedes\": \"\",

\"datosOriginales\": \"\",

\"codigoMensajeSeguridad\": \"\",

\"tagsAdministracionRedes\": \"\",

\"valorVerificacionAutenticacionTitular\": \"\",

\"indicadorComercioElectronico\": \"\",

\"idProtocolo\": \"\",

\"idTransaccion\": \"\",

\"tarjetaARecargarEncriptada\": \"\",

\"tarjetaEnmascarada\": \"\",

\"datosPagosDigitales\": \"\",

\"cardVerificationEncripted\": \"\"

}

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \" \",

\"dispositivo\": \" \",

\"idioma\": \" \",

\"portalId\": \"PBN\",

\"uuid\": \"1623474121595947:B6AE4261BD4594A746DF1FF9CECF85A32BCADCA1\",

\"ip\": \"200.115.33.10\",

\"horaTransaccion\": \"2025-03-28T13:46:52.308ECT\",

\"llaveSimetrica\": \"Om70LSqGaLPdkJxFUJ4oz3OvWPz5ZOj6gTDgaIHmZRmbUi0uYHO6X9gPEsyQWY4tw8afmd8RuF90+bhD8J0ZWPQBHL57O7O5HaUAq3yUbYOAH0jwR7hHOujyh4Vofd3bAjf9gzdgKdQY7roJrsBel0t9zH+f2oWbOi6r0NaFltzVgpTT3OlDHfu9/zwOUEzMTHwNVj+MbjXnHsdFgwSdHVoX6pdlNoeK8OJEjuzGfb6l0z3l5dKm2sPyawVYrWQJ8ZOL4VZCFyTjd6Q+FEqK9/SEyBiGlryLg5rvelUJjJXbKUMGaYPxclEBtYoLf8HqMwjgG6pE8dE27Xkg5CpzqA==\",

\"usuario\": \" \",

\"paginado\": {

\"cantRegistros\": 10,

\"numTotalPag\": 1,

\"numPagActual\": 1

},

\"tags\": null

},

\"dinBody\": {

\"numeroTarjeta\": \"6PcDHGa844DHeYJuOamc3Wni8QrL4s1U3ij5nTxFRgC8UcPrg45vcNfJSBM=\",

\"codigoTransaccion\": \"003000\",

\"montoTransaccion\": \"000000002800\",

\"fechaHoraTransmision\": \"0220224723\",

\"numeroSeguimientoAuditoria\": \"000486\",

\"fechaExpiracion\": \"1249\",

\"idDatafast\": \"01791219058\",

\"idEmisor\": \"\",

\"track2\": \"\",

\"numeroReferenciaTransaccion\": \"505122020486\",

\"idTerminalEstablecimiento\": \"H0000095\",

\"idEstablecimiento\": \"0001215955\",

\"nombreEstablecimiento\": \"BDO\*MPOSCAL3SALUD Quito ECU\",

\"codigoMoneda\": \"840\",

\"datosSeguridad\": \"\",

\"circuitoIntegradoTarjeta\": \"\",

\"informacionProductos\": \"\",

\"tagsAdminstracionRedes\": \"\"

},

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T13:47:02.803ECT\",

\"origen\": \"As400 CAO\",

\"codigo\": \"\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"Transacción negada\",

\"detalle\": \"Transacción negada\"

}

}

**Ejemplo de request (Caso fallido):**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \" \",

\"dispositivo\": \" \",

\"idioma\": \" \",

\"portalId\": \"PBN\",

\"uuid\": \"1623474121595947:B6AE4261BD4594A746DF1FF9CECF85A32BCADCA1\",

\"ip\": \"200.115.33.10\",

\"horaTransaccion\": \"0220224723\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \" \",

\"paginado\": {

\"cantRegistros\": 10,

\"numTotalPag\": 1,

\"numPagActual\": 1

},

\"tags\": null

},

\"dinBody\": {

\"codigoRuteo\": \"T\",

\"mensajeId\": \"0200\",

\"codigoTipoVia\": \"40\",

\"numeroTarjeta\": \"md3Ovx9xLv++13qwpksrlmO+EvI4sq8hkhfdqC2naPKzykLi3jMH5hDSaPk=\",

\"codigoTransaccion\": \"003000\",

\"montoTransaccion\": \"000000002800\",

\"fechaHoraTransmision\": \"0220224723\",

\"numeroSeguimientoAuditoria\": \"000486\",

\"horaTransaccion\": \"224723\",

\"fechaTransaccion\": \"0220\",

\"fechaExpiracion\": \"\",

\"actividadComercial\": \"5122\",

\"tipoLecturaPOS\": \"010\",

\"secuenciaNumeroTarjeta\": \"001\",

\"idDatafast\": \"01791219058\",

\"idEmisor\": \"00000369696\",

\"track2\": \"\",

\"numeroReferenciaTransaccion\": \"505122020486\",

\"numeroAprobacion\": \"14\",

\"codigoRespuesta\": \"00\",

\"idTerminalEstablecimiento\": \"H0000095\",

\"idEstablecimiento\": \"0001215955\",

\"nombreEstablecimiento\": \"BDO\*MPOSCAL3SALUD Quito ECU\",

\"track1\": \"\",

\"codigoSeguridad\": \"RdS9+KCzcZj5CMH59GxPTgULiOla1ck9GEyxjQTrTg==\",

\"codigoMoneda\": \"840\",

\"pinBlock\": \"\",

\"montosAdicionales\": \"20\",

\"circuitoIntegradoTarjeta\": \"\",

\"informacionProductos\": \"00003001\",

\"valoresAdicionales\": \"053128209984509043783Linea 342 \",

\"datosPOS\": \"00\",

\"codigoAdministracionRedes\": \"\",

\"datosOriginales\": \"\",

\"codigoMensajeSeguridad\": \"\",

\"tagsAdministracionRedes\": \"\",

\"valorVerificacionAutenticacionTitular\": \"\",

\"indicadorComercioElectronico\": \"\",

\"idProtocolo\": \"\",

\"idTransaccion\": \"\",

\"tarjetaARecargarEncriptada\": \"\",

\"tarjetaEnmascarada\": \"\",

\"datosPagosDigitales\": \"\",

\"cardVerificationEncripted\": \"\"

}

}

**Respuesta**

{

\"dinHeader\": {

\"aplicacionId\": \"PTP\",

\"canalId\": \"IN\",

\"sesionId\": \" \",

\"dispositivo\": \" \",

\"idioma\": \" \",

\"portalId\": \"PBN\",

\"uuid\": \"1623474121595947:B6AE4261BD4594A746DF1FF9CECF85A32BCADCA1\",

\"ip\": \"200.115.33.10\",

\"horaTransaccion\": \"0220224723\",

\"llaveSimetrica\": \"mDjnYdAON572Ed26RFChlRC4g9mPLmddNlS1Nf2kYvD9ialXeHv7Wyzwf7nL3tC7kTuA4ODVQ+d745yyZPcVEYIlJrLtoiNSeFsFWtH2O1GKrKhg6k+kqVhMaQ3Z1nLS0F31RWUKvS35IZWxJMx78hXipzzaQxW1QnsnCpJ+RIa/YGtKuX7Ez05ckrxQYItrlPYGHskNf4gWFrpnRnU6XwixvfRycpFz2SmnRjQSD676XTYxI/0GMWF+2dRXiIOKlpRGBdREnLBgzONB8nBU7lsQAUU666TzF5P+xFh0254DY+0NMjLMwpfQfLVyzQjK1RJdUyOYkQt6JTTBs3VrWQ==\",

\"usuario\": \" \",

\"paginado\": {

\"cantRegistros\": 10,

\"numTotalPag\": 1,

\"numPagActual\": 1

},

\"tags\": null

},

\"dinBody\": null,

\"dinError\": {

\"tipo\": \"N\",

\"fecha\": \"2025-03-28T13:48:01.250ECT\",

\"origen\": \"MS\",

\"codigo\": \"0002\",

\"codigoErrorProveedor\": null,

\"mensaje\": \"El valor del campo fechaExpiracion es requerido\",

\"detalle\": \"\"

}

}

### Body cifrado en peticiones/respuestas 

A continuación, se describe cómo se debe manejar el cifrado del body en las peticiones y respuestas entre el backend de la Pasarela de Pagos y DataPower. Este mecanismo será utilizado para los servicios de Generar OTP, Validar OTP, Consultar Tipos de Crédito, Cálculo de Interés, y Autorización de Consumos. **Cabe destacar que para el servicio de Consulta de llave RSA pública, no es necesario cifrar el body de la petición.**

El proceso para cifrar el body se realiza una vez que todos los campos necesarios han sido construidos y organizados según el contrato de cada servicio. Una vez estructurado el body, se procede a cifrarlo en su totalidad, garantizando que todos los datos sensibles y operacionales estén protegidos durante la transmisión.

El objetivo es que todo el contenido de la petición o respuesta viaje cifrado, brindando una seguridad adicional en la comunicación. De este modo, se protege tanto la información sensible previamente cifrada como el resto del body.

Este enfoque simplifica el cifrado independientemente del tipo de transacción, garantizando la integridad y confidencialidad de los datos en cada intercambio.

**Entrada:**

**Cabeceras HTTP**

<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 9%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 25%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr class="header">
<th><blockquote>
<p><strong>Campo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Tipo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Longitud entera</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Longitud decimal</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Formato</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Campo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Descripción</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Valor del campo</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>x-aplicacion-id</td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td><p>El código relacionado al aplicativo o sistema consumidor del servicio.</p>
<p>Es obligatorio porque las llaves pública y privada con las cuales se encripta y desencripta la llave simétrica están asociadas al</p>
<p>aplicativo y canal.</p></td>
<td>Ejemplo: PTP=Place To Pay</td>
</tr>
<tr class="even">
<td>x-canal-id</td>
<td>String</td>
<td></td>
<td></td>
<td></td>
<td>Obligatorio</td>
<td><p>El código del canal consumidor del servicio.</p>
<p>Es obligatorio porque las llaves pública y privada con las cuales se encripta y desencripta la llave</p>
<p>simétrica están asociadas al aplicativo y canal.</p></td>
<td><p>Valores posibles: IN=WEB</p>
<p>MB=Mobil</p></td>
</tr>
</tbody>
</table>

**Cuerpo (Body):**

<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 9%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 25%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr class="header">
<th><blockquote>
<p><strong>Campo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Tipo</strong></p>
</blockquote></th>
<th><strong>Longitud entera</strong></th>
<th><blockquote>
<p><strong>Longitud decimal</strong></p>
</blockquote></th>
<th><strong>Formato</strong></th>
<th><strong>Campo</strong></th>
<th><blockquote>
<p><strong>Descripción</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Valor del campo</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>body</td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td>En este campo viene el request json enviado de forma encriptada con la llave simétrica y el vector.</td>
<td></td>
</tr>
<tr class="even">
<td>secretKey</td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td><p>En este campo viene la llave AES.</p>
<p>Ejemplo en claro:</p>
<p>Llave-AES-EnBase64</p>
<p>Una vez generada la llave se debe cifrar con RSA y codificar en Base64</p></td>
<td></td>
</tr>
</tbody>
</table>

**Salida:**

<table>
<colgroup>
<col style="width: 11%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 24%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr class="header">
<th><blockquote>
<p><strong>Campo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Tipo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Longitud entera</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Longitud decimal</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Formato</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Campo</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Descripción</strong></p>
</blockquote></th>
<th><blockquote>
<p><strong>Valor del campo</strong></p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>body</td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td>En este campo viene el request json enviado de forma encriptada con la llave simétrica..</td>
<td></td>
</tr>
<tr class="even">
<td>secretKey</td>
<td>String</td>
<td></td>
<td></td>
<td>Base64</td>
<td>Obligatorio</td>
<td><p>En este campo viene la llave AES.</p>
<p>Ejemplo en claro:</p>
<p>Llave-AES-EnBase64</p>
<p>Una vez generada la llave se debe cifrar con RSA y codificar en Base64</p></td>
<td></td>
</tr>
</tbody>
</table>

**Ejemplo:**

**Petición:**

{

\"**body**\": \" 14X99Q9RajQX2zjdH6dCcFER1l6mtzmoUZVJuQPQIW7KbwPyfv1HQREJBHqRxS9wjRwloWpsL/cxnG2Mr28X9QzKGv/i2MiHkFv94LiReTndwh3mp2JIucRColOzhL/Y03svIpZ6K7yc71Db5v/4qTCl9oazmYIByjkTuDhZ3Gs3HU77kNZHOsBJfpLgUybu+r3cur1KHaiYviy7ed7PpN/B8bGCS/8gmvITW/O8BygWX8S4WUhHUcoAH1kIJFZ/ISa7p/xV63tL5chzThjyK6Ih79YIdKZelW+Bp1MJRf+ciTneo9pUwdzwQSsIhKAmWOo6JzJU0qQIJQnDYkV+Ycr+Ud2Ifx0+hNPyYA2V5CfUsbfIr8CjDGaX+eenwFlkb1Nqfvu78oR2ZEIph63uuQTfKKqHYPJc2PDavh/r8c+veMR/Vpx1PN6QJ/Sr5fQOqDa+4hDvT17+1Ps6et4ZG2/tPkal74z+FyyjWlU++N2y8UPdkuFN0sozpzQyfPh4vmHqdx59zfQDsWHKh6MA8p63yhXy6Itf/aeVvOv0JO2uoQgB4PWfJMByJpsX4Owo/j6eV7KHlJy2Mg8gVeij8jcap+9yErrSxaXAl7BEequzqiT1ncAMRODZC39epGrnzUJUp3+kKaq+ZUAV224+s1qSLg0IyStbLBWfQYtcfab5RjXsgHAcRgX3LMBKJoUfjXQLdloKbfoZpC6ODqpFSKQWgC8XQ2Ogcel5Vdt6V32xUI8/eJynYgipve2KyNjN9kHq+8SfSbKmswCfEeWab+OVSb/XenfkYpIJ3DL2qH9EWfZY/vxj8ZiwXIaWzXjAz2ETwjvJPDGcttcw65/6YPT4ZkaDqehnfk0Aeod8s4o0LtvTU4KdpjxWwBreWlkH+Kdc5SCimICsjeSoGkdsBgpCv+yRywx8lBJPjJHCDg9Yq0bIPw1eZ7XMqZ5J9d9QQzXlYVGhrIj8p5Su7YOObyTxqg2z0k+K2HEL8MwOVowD5HcvVVO3PIGQnXzRFbKamO05B2eo/T4K6lyfZLL3rTC6LDBI7+oY7CHMoWuWtI01nt9a6JpsxN0kbeUxY8OWTxw9SrJpek0WxrlevQW3GBI9qfRGMTEmuKbI6XvPf6ynKE9T/Adtef3KeQSShWvAWvGdArAljI/YTGvcq6f7RFFWkJsXeShtZfs4cWfPm1+VZsgyqUJDu9tph1Y/c+qIGdlnojy+CYIdlDG8/JyfJmnfHP0AgBaZ/UbBcvSWMgHSn+JG6at5VNms9kM0AXFLk14/UXjS79XkYSiXzrGYLtCxPy7rVPOE54If5BNk3kf1OxPGWs1VvjTQ5ZJOUUNp0nN7LyVWs1sPVuJEyyFlvkp6AMzVls0BoKWG49n/S05+OpyATi5BD8jeD/mAgDFYnIOOY327dH1Wh0t6mSLP1oOWgFebGRynUAh4DbNiUVbi5BiEFi+Flicuh0XOC7QWFRiWixt+nVY6BnFgixJ4kQgMXPgfA342BdjG+hzmMfY2DJf4egrz7Yzd40GaHxGZS/xXoHL40E5EH4+4VCrGHi5YCez6OLfKO9s37mvHGDY12N3/MMdj6Sw/dYcFmC3jj6nYdh0DdNPHNjd5537un2rnManpXcOECsgYRHx1l1GDmf0y3faPtBpbneXseIunaEOqgANfWTicLCJ99RcOFhjP7bgPjDnm8IzlbACLvxiW3PEZEecFUv/LwIDShQIezw+hZmmWsc89iOHfkC6wjHGh1Uxvu2AFCPyYSOQnqU7fkGXoPekYEuVRhIQZ92kDeWBl6/vVNl3gDmQzodZkKTns6754x2jdxmnpsmrpw5AFrWB/uMBjOeKzwGwziNDUTvtA/LxKC7cvAaVuw8q94+NrLg8Y6sJzsoZnZcC3tOZtt+R7h8SZcqDMrDCC60C76mnl1yefgOQk8PFT8hft9Tb13tueLQBHbrB0Dg58X+3k0z/CpW+ySlMMWQB9sJu/c0KCuUcseUaA66EIiAG0AUSj4OqqukS4uWlGw7vP2rdzv2XOaNSy+svAzOwNVE40Zbb+XX6NzUJ7npWb3rl3RsJ0FO1ffwd+oYRA71EGFtaI6h9QZf03zkLXfti5ZRggHXS8fQQTFUBOFRjmI70jxWM12nQyEod/whBnM/TmiPRHz0brJd7WVfoKxcCvD7N21GtARcUrO5BWXRhxCYlKTTeErxaAYUxWI0RnKNRBvNcihywQSvkWSxmspE0eakPGlyh0MHOF4yKDWBJnnqj0lQc+rPvnLn+IusB15hM5WPM03R9qNwzAyMUkd2ALxIj6z5U9EhrFwvlUG/WOUbypPsj2XJqnNmDIFUba93495LM+Z8gYBMmAvygzkGhWbdItiubtmGceknaRJFKgrRuER7c4kOLRJzKPZFAqXx69sFGKQNYTnC/ZLOHjGVReIjdbAyMjHdz55bLE1FvwMVxkzSL29UjqVobBpMuWKQ3zDW1lIhj65ZEitZwFf6nYqfA51er7b9wExyDOA9I+IG33nkzYBogDeWWuyqmLR8KMyK7JuPk0D3cE9rVRu0nu1yUQbMLoYM715vR9XJATq5GJsONXuG0NLBfhrncBD1Axf73tMkGOYQTlOx+uSM9cmGidqTJKYTez2ZyhPgggGvmE/QLx4CxGSrj+nJkwcuSfeH2w4uAB8qqDT+683rMUonDZAFhUXil5peVzIuY/Uex7cSyB4kkT82gpavPj3FGGotnCC2uPIe4YDtfZjceTsm63Lf057pQIdgda6cbnuN8dnFBD1l2Ra668TUiw6oy7VyYnZLhltHyCJtxyrw1WlcaqOGR7k+xh0AEvf9tU3u/t6NNE18Szc0b+ww05m3bNbNz4PQ7py4vVi5DWJUqldYrCDuoohtToMVq1YRD/pxMhsJnftgfaU0zb8wk33yb1dS55rNJkuhZxpgcugiZrLkKouczFmhmsMJR7yMBk8Qj5lEZvIb0TVX0+rmCa9uDZiSrLyNY7C7Cei2M31OKvUDpiEjges4n9A8D8YUiadDYYy9AboEdtx+VOastbYvVznYKIWQlrYKFqLVH9iDWj7pcehEkfJR6JbRaje6av7kfl7wElVm+hb4RcDFTnzkQzJfZMu9ku55vEpZmyq2fnq7U5iUO+Olt5C6sQdVmQAUVKI607FtI3QAL0/D+FqCHE50Fz1p2A6rQHxbE4zYx2TF+9vylYrlG9uEz6S3C6pAD7vHG27b2rFK3GK3BxJ0gqVAy6Wh1CaW8F2pbKB57qTTSwT4KNff408HsRYZEBJqIiRk3EwTGTAyNwGdJ8mm27eoZw0CgNDmvxvZPefTXwHPODLPRwrfxCP/kGdZCq4+hKtAUQdOihqeysl9+Qw9J71ce9TXwv8heM1A2vU+mxTaS3sgNpkzgBOfW77lPMGjAYvqzLi6JshVzq9LzVCWI0WBzb55/eHLXChxenAThLy13bnUh4aIQxXOR4Hr+bZRt+YQ/hRfmH3eXpS2P3jYry0B72v4LccCy29D62krrDUOhwWE5qefYsxc6JIKbG+ZQXF3zvTI6dQXsAAMovXJdFE2z/KbCCVbksO0H4FCr7uYPVMS77CADniKhMgXtER9P5Gs9dSBUA508kQAiL+jzOZU0nvm9CRW6wmQ==\",

\"**secretKey**\": "fXHsd3L+B0Q6KzzF7G+G5FXVoStcn8jV0sUdhBQNBlmDpbbvyupnoMDL5Qq4YWaGWsbAagrPaelRKJJW6Gdmmicv6nSk9yGT96DX5TUN7UDI64oR+s8IcniQAyDtD0nrZ8aHP2wCY6J7C7cjNTIecCTLI91BLAZQhBfougm5jm5ZtNstQk6ortd2VGj7fJxzBjbdrEDQVtRWHr0SIkhoA1ubqex1yZtg9fyM76gy35tHENN5gGCA6tTEWgzutatewGBnVyfSEASGbYrB8TZHcIVlwBD35lmXnu5QqgNsSnrq1ZMRDfpgoALGTfhgX31Y1to5htrX3oNMNnSG7W+00Q==\"

}

**Respuesta:**

{

**\"body\":** \" LXBN7oHimppXXM1+n5rP8UGgxhxx1jEmY/HVCmM6AVqNUsh9Q009tT6kDJ3Z2zuJzeT14c4sDO0s5hR6S5dDTIvGYF31exELPJxYxhJ9Wq9NTG0FYd8G2iyfU1fUaGxecU5BjTkF80H/bAeEuKVmqn0RDjl/5pxRzQuvvfaozLGeG+M4k1axFyIgkJJloGXXcuKfXwRtJivHMBuNp+d44UsMX/yeYmenfi0yfRSl310wqZvINv1TQ+00gfl9mhL+fec/b/oF4PPmhSxoXqX/Dz6L6hT07wA9/XVE+d3Q0RfbRM7xgzQorteSZYTVFzLxfSC35e9kBZGsSmiAG31TZyrsXOwKuhMDX8yakpasI9HRPGYogmtb6gt1Tp6PBngCmzzteNEUgFEKH6nG/WGXJcMct2Op85gvkhGIsjZZvTbD/pNQTU7Vp4S0wLhTezTDgE7Rvxx3YpKrvExACo5tTJ3bseUgGfnoR1rh700Mhtpa6zgAxNqM7VPwXWbFoH7whfAZ4z6F4naqfoArC6lxM7cX3pOcFYo1DumrU+16tCjs4MK/DsBulOE6q+F9pszsJC5XOr9RktVbReMpPOH5FIvusIFqUCq7jrp/7T9unktR6lpeJmFpFAnpURNUW/8lpelobXWFM9Z/1CPF1It0MEwzypu4q9jXiZDUOnoM2gQRHpbmTlyBk5Bmmdj8wflLzI1mZk0P1A7ngen7EoEEDou48MLTDu3C+OqAfoKalgJcnrFZ257LHC60cVcullYaPURo6R3qyps9q99eN81/ZJRmt2D/REadQOPwzX8qhfapF9H+Jv1F1VWmqZ8wqeaZ5gVpNExiC9ip5QBgIa8ifp5ePJCK4CKFRK98s1Aj6NToFqjkie+2Lj3CKrdmgqwfrLIYAAMex5+GNgLLfIe1tIjjcCABcxgvEnjvz6/WYfYVW8u0YbAHcMLZ2YzbETg18n4YWHOvJolHydxQDpug6cpzugomq2ynVI4wpoGki8ARCA76+pcj9Zs5SmjcZ93IFpvQDBNeckySGX2LU5aVw+53OQH0DVp7zuTjXLEmFpRgTw4+sOqY3GDr6AIDITzgFsprd06MO7x/hkr7nnp6D9zSMnXDl/n1KoYSgWeST+TRRg/vVKd5AMSjV5CnSdrQnw0mxfROCdSWoaZQxiRTLkH6A9WUeDndsYrFgnSGll801ZtA6yCqnfOsPJVB/ZsZCXM4d869+5R7tohsf3h/FvA2HVFlIRfg3Ck1ykE+9+V11n5mfzicG3CERyKDAPEgdFbNz6WuQ0fdt4T0zw/HhY4TwlnB6EK/bs15HgNp0TULauTdyVCj44rJJOn1iYF8o1pNqCTEtsu7+UkHsk664euVjlQvcGJgiD1iDOXVZwiALbjrFMTyySvf03mdn4NjYtTBiXM9RM+jiJg73tmAWQn2uAJiLq+u/Dq6+qQGtgYqvY3OykdM6MHXgKO4Vj8MMOuHvKuI/TZpvSQ1/SkAJuWLF8tXRtwWBKteDZqTtUQugTimhDQK9AJorJpSp0U7YJQCKQqlKh776OzOIMvgk3jNrQzOjKpgsZ0pEEYqwtheSXcfMDLOnG+DtAFCdCYVMD2Q\",

\"**secretKey**\": \" fXHsd3L+B0Q6KzzF7G+G5FXVoStcn8jV0sUdhBQNBlmDpbbvyupnoMDL5Qq4YWaGWsbAagrPaelRKJJW6Gdmmicv6nSk9yGT96DX5TUN7UDI64oR+s8IcniQAyDtD0nrZ8aHP2wCY6J7C7cjNTIecCTLI91BLAZQhBfougm5jm5ZtNstQk6ortd2VGj7fJxzBjbdrEDQVtRWHr0SIkhoA1ubqex1yZtg9fyM76gy35tHENN5gGCA6tTEWgzutatewGBnVyfSEASGbYrB8TZHcIVlwBD35lmXnu5QqgNsSnrq1ZMRDfpgoALGTfhgX31Y1to5htrX3oNMNnSG7W+00Q==\"

}

## Estándar de cifrado

Para garantizar la seguridad de los datos que se transmiten entre los servicios de Diners y la pasarela de pagos, se implementa un proceso de cifrado que emplea criptografía híbrida, combinando algoritmos de cifrado simétrico y asimétrico. Este proceso asegura que tanto los campos sensibles como el body completo de las peticiones y respuestas estén protegidos durante la transmisión.

**Algoritmos de Cifrado**

-   **AES-256 (Simétrico):** Utilizado para cifrar los datos sensibles y el body completo de la petición/respuesta.

-   **RSA-2048 (Asimétrico):** Utilizado para cifrar la clave simétrica AES.

**Proceso de cifrado en las peticiones**

El cifrado de las peticiones se realiza en dos etapas utilizando AES-256 en modo GCM, y en ambas etapas la llave AES se protege mediante cifrado asimétrico (RSA-2048), las etapas son:

1.  **Cifrado de Campos Sensibles (con AES-256-GCM):**

-   Los campos sensibles en el body de la solicitud, como el número de tarjeta, CVV, fecha de expiración u otros, deben ser cifrados de forma individual utilizando AES-256 en modo GCM. Dentro de la especificación de cada petición se indica cuáles son los campos cifrados.

-   Para este proceso, en cada solicitud, la pasarela de pagos debe seguir las siguientes recoemndaciones.

    -   Generar una llave de 256 bits (32 bytes) utilizando un generador criptográficamente seguro.

> **Para cifrar:**

 

> -       Generar un Vector de Inicialización (IV) aleatorio de 96 bits (12 bytes), debe ser único para cada operación de cifrado.

 

> -       Configurar el cifrado utilizando AES-256 en modo GCM, estableciendo un tag de autenticación de 128 bits (16 bytes).
>
>  
>
> -       Convertir el texto claro a una secuencia de bytes utilizando codificación UTF-8.
>
>  
>
> -       Se aplica el cifrado sobre esos bytes, produciendo el ciphertext que ya incorpora internamente el tag de autenticación.
>
>  
>
> -       Concatenar el IV generado al inicio del ciphertext.

 

> -       El resultado (IV seguido del ciphertext) se codifica en Base64 para facilitar su transmisión vía REST.
>
>  
>
> **Para descifrar:**

 

> -       Se recibe el mensaje cifrado en formato Base64 y se decodifica para obtener la secuencia de bytes completa (que contiene tanto el IV como el ciphertext).

 

> -       Se extraen los primeros 12 bytes de la secuencia, que corresponden al IV utilizado durante el cifrado.

 

> -       El resto de la secuencia se considera el ciphertext, que incluye el tag de autenticación.

 

> -       Decodificar la llave en Base64 para obtener la representación binaria necesaria para el descifrado.

 

> -       Configurar el descifrado utilizando AES-256 en modo GCM, utilizando el IV extraído y el mismo tamaño de tag (128 bits).

 

> -       Aplicar el proceso de descifrado al ciphertext; si el tag de autenticación es válido, se recuperan los bytes originales del mensaje.

 

> -       Finalmente, se convierten estos bytes al formato original (la cadena de texto en UTF-8).
>
>  

-   Una vez que los campos sensibles han sido cifrados, la llave AES usada para cifrar los campos sensibles se deben codificar en Base64, posteriormente cifrar con RSA-2048 usando la llave pública de Diners asignada a la pasarela y que está disponible a través del microservicio de consulta de llaves públicas (msd-can-int-llavespublicas), ver apartado [Consultar llave RSA pública](#consultar-llave-rsa-pública). Esto garantiza que la clave no se transmitan en texto claro.

**Ejemplo de estructura de la solicitud con los campos sensibles cifrados:**

![](media/image3.png){width="4.55529636920385in" height="2.0896303587051617in"}

2.  **Cifrado del Body Completo (AES-256-GCM):**

-   Después de cifrar los campos sensibles y ensamblar el body de la solicitud, se procede a cifrar todo el body utilizando AES-256 en modo GCM. Este paso asegura que todo el contenido de la petición esté protegido.

-   Para este cifrado, se genera una nueva llave AES de 256 bits y codificarse en Base64, el resultado debe ser cifrado con RSA-2048 para proteger la llave.

**Ejemplo de la solicitud final cifrada:**

![](media/image4.png){width="4.555653980752406in" height="0.7719542869641295in"}

**Proceso de cifrado en las respuestas**

El proceso de cifrado para las respuestas de Diners sigue el mismo esquema que el descrito para las peticiones:

-   Los campos sensibles de la respuesta se cifran utilizando AES-256 en modo GCM.

-   El body completo de la respuesta, incluyendo los campos cifrados, se cifra utilizando AES-256 en modo GCM.

-   Para el cifrado de la clave simétrica AES generada por Diners, es necesario utilizar la clave pública RSA de la pasarela de pagos. **Esta clave pública debe ser proporcionada previamente por la pasarela de pagos** y es almacenada de forma segura en el entorno de Diners**.**

**Resumen de la implementación del cifrado en la integración**

-   **Entre la Pasarela de Pagos y DataPower:** Todo el body de las peticiones y respuestas debe estar cifrado utilizando AES-256 en modo GCM. Además, los campos sensibles dentro del body ya estarán cifrados individualmente utilizando AES-256 en modo GCM. DataPower es responsable de descifrar el body completo de las peticiones y volver a cifrar el body de las respuestas.

-   **Entre DataPower y los Microservicios de Diners**: Las peticiones se transmitirán en texto claro, excepto los campos sensibles, que permanecerán cifrados individualmente. Los microservicios serán responsables de descifrar los campos sensibles en las peticiones y de cifrarlos nuevamente en las respuestas.

A continuación, se grafica la secuencia de pasos para el flujo de cifrado desde la pasarela de pagos hacia Diners y viceversa:

![](media/image5.png){width="5.905555555555556in" height="5.458333333333333in"}

## 4.3. Anexos sobre la definición de campos en las peticiones/respuestas {#anexos-sobre-la-definición-de-campos-en-las-peticionesrespuestas .unnumbered}

### 4.3.1. Detalles de estructura DinHeader {#detalles-de-estructura-dinheader .unnumbered}

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 16%" />
<col style="width: 35%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Nombre</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>aplicacionId</td>
<td>String</td>
<td><p>El código relacionado al aplicativo o sistema consumidor del servicio.</p>
<p>Es obligatorio si se envían datos encriptados porque las llaves pública y privada con las cuales se encripta y desencripta la llave simétrica están asociadas al aplicativo y canal.</p></td>
<td>PTP=Place To Pay</td>
</tr>
<tr class="even">
<td>canalId</td>
<td>String</td>
<td><p>El código del canal consumidor del servicio.</p>
<p>Es obligatorio si se envían datos encriptados porque las llaves pública y privada con las cuales se encripta y desencripta la llave simétrica están asociadas al aplicativo y canal.</p></td>
<td><p>Valores posibles:</p>
<p>IN=WEB</p>
<p>MB=Mobil</p></td>
</tr>
<tr class="odd">
<td>sesionId</td>
<td>String</td>
<td>Es el identificador único de la sesión generado por el consumidor del servicio. La sesión debe ser única por todos los servicios de una misma transacción,</td>
<td><p>Ejemplo:</p>
<p>8b97a6b0-3d76-4c86-a9ee-9199247df244</p></td>
</tr>
<tr class="even">
<td>dispositivo</td>
<td>String</td>
<td>Es el identificador del dispositivo donde se genera el consumo del servicio (Opcional).</td>
<td>Ejemplo: “”</td>
</tr>
<tr class="odd">
<td>idioma</td>
<td>String</td>
<td>Es el idioma asociado al dispositivo donde se genera el consumo del servicio (Opcional).</td>
<td>Ejemplo: “”</td>
</tr>
<tr class="even">
<td>portalId</td>
<td>String</td>
<td>Es el identificador del portal de donde se consume el servicio (Opcional).</td>
<td><p>Ejemplos:</p>
<p>PIN (Utilizar para endpoints de generación/validación OTP)</p></td>
</tr>
<tr class="odd">
<td>uuid</td>
<td>String</td>
<td>Es el identificador único de la petición o invocación del servicio generado por el consumidor del servicio.</td>
<td><p>Ejemplo:</p>
<p>4A1B43E2-1183-4AD4-A3DE</p></td>
</tr>
<tr class="even">
<td>ip</td>
<td>String</td>
<td>La dirección IP del servidor que origina la petición del servicio.</td>
<td>Ejemplo: 192.168.5.1</td>
</tr>
<tr class="odd">
<td>horaTransaccion</td>
<td>DateTime</td>
<td><p>La fecha y hora de la transacción. Formato:</p>
<p>AAAA-MM-DDTHH:MM:SS.mmm</p></td>
<td><p>Ejemplo:</p>
<p>2023-01-31T15:03:01.001</p></td>
</tr>
<tr class="even">
<td>llaveSimetrica</td>
<td>String</td>
<td><p>La llave simétrica para desencriptar los datos encriptados por el consumidor, en el caso de que no esté presente implica que no existen datos encriptados por el consumidor (opcional).</p>
<p>En este campo viene la llave AES.</p>
<p>Ejemplo en claro:</p>
<p>Llave-AES-EnBase64</p>
<p>Una vez generada se debe cifrar con RSA y codificar en Base64</p>
<p>Ver más información en <a href="#estándar-de-cifrado">Estándar de cifrado</a></p></td>
<td>Ejemplo: VdUg04mV5mngVMTLn9lLubn18m8fxA4RhMlWdnlST6uHSQJzBXocGmiX4QA512RbSg17rZ1jh8C+eX6Zv2sD4I9gV450uDw4mbfQOrgPwQ3LU98408hkawzvJz7ugF20bVOcRIHKinIYdUFFonJYueg+FXWsbnzUfd5fm4Fwf5jqAkRV1LvWhPnsDm5OzXrncu5E6fo8Hc9QCXNla3eItXY08guQVVGMcKOW1xEyDwZCpDAdnvwNNkPmzXJdtzb7FGmRjowNzAX+vC2/gRFlWdQJNjXSL+XR+usv9vazONA0ds8ZHFBL89MhMKYJBcfq5AYm9/Rz8+N64fFylBZ/Cw==</td>
</tr>
<tr class="odd">
<td>usuario</td>
<td>String</td>
<td>El usuario asociado a la transacción (Opcional).</td>
<td>Ejemplo: “”</td>
</tr>
<tr class="even">
<td>paginado</td>
<td>Estructura</td>
<td><p>Contiene la información necesaria para manejar la paginación a nivel del servicio (opcional).</p>
<p>Si no se maneja paginación y se envían los campos estos deben enviarse con 0.</p></td>
<td><p>Ejemplo: "paginado": {</p>
<p>"cantRegistros": 0,</p>
<p>"numTotalPag": 0,</p>
<p>"numPagActual": 0</p>
<p>}</p></td>
</tr>
<tr class="odd">
<td><strong>tags</strong></td>
<td>Estructura</td>
<td>Contiene datos adicionales (Opcional).</td>
<td>Ejemplo: “tags”: []</td>
</tr>
</tbody>
</table>

### 4.3.2. Detalles de estructura DinError {#detalles-de-estructura-dinerror .unnumbered}

<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 15%" />
<col style="width: 45%" />
<col style="width: 23%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Nombre</strong></th>
<th><strong>Tipo</strong></th>
<th><strong>Descripción</strong></th>
<th><strong>Valor</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>tipo</td>
<td>String</td>
<td>El código relacionado al tipo de error que produce el servicio.</td>
<td><p>Valores posibles:</p>
<p>N = “Negocio”</p>
<p>T = “Técnico”</p></td>
</tr>
<tr class="even">
<td>fecha</td>
<td>DateTime</td>
<td><p>La fecha y hora en la que se registró el fallo con el siguiente formato:</p>
<p>AAAA-MM-DDTHH:MM:SS.mmm.</p></td>
<td><p>Ejemplo:</p>
<p>2023-12-31T15:56:38.001</p></td>
</tr>
<tr class="odd">
<td>origen</td>
<td>String</td>
<td>Es donde se originó el error</td>
<td><p>Ejemplo: “Programa RPG X”</p>
<p>Ejemplo: “MS”</p></td>
</tr>
<tr class="even">
<td>codigo</td>
<td>String</td>
<td>El código de fallo en Diners</td>
<td>Ejemplo: “0011”</td>
</tr>
<tr class="odd">
<td>codigoErrorProveedor</td>
<td>String</td>
<td>El código de error del proveedor cuando se realicen consumos a terceros (Eg. T24)</td>
<td><p>Ejemplos:</p>
<p>Cuando se obtenga desde proveedor :“PROV1121”</p>
<p>Cuando no se integra a proveedor: “null”</p></td>
</tr>
<tr class="even">
<td>mensaje</td>
<td>String</td>
<td>El mensaje de fallo generado por el microservicio.</td>
<td>Ejemplo: “Tarjeta inválida”</td>
</tr>
<tr class="odd">
<td>detalle</td>
<td>String</td>
<td>El detalle del mensaje de error generado por el microservicio.</td>
<td><p>Ejemplo: “Tarjeta del cliente está caducada”</p>
<p>Ejemplo: “”</p></td>
</tr>
</tbody>
</table>

### 4.3.3. Campos del servicio de autorización de consumo {#campos-del-servicio-de-autorización-de-consumo .unnumbered}

#### 4.3.3.1. Campo codigoSeguridad {#campo-codigoseguridad .unnumbered}

Destinado a agrupar una serie de subcampos en formato trama, tiene la estructura y orden son descritos en las siguientes estructuras.

Estructura Principal. - formado por la categoría, código de marca y código de subcomercio

Los datos de la categoría de la transacción o TCC tienen los siguientes valores posibles.

![](media/image6.png){width="5.905555555555556in" height="2.6333333333333333in"}

Ejemplo: \"R3734011100000246589031500004795 \", donde.

  -----------------------------------------------------------------------------------------------------------------------------------------
  T o R             TCC
  ----------------- -----------------------------------------------------------------------------------------------------------------------
  37                Longitud total de datos

  34                Longitud de sub elementos

  01                Sub elemento 01

  11                Longitud de sub elemento 01

  **00000246589**   Código de marca asignado por ella (para diners o discover deben enviar ceros=00000000000)

  03                Sub elemento 03

  15                Longitud de sub elemento 03

  **00004795**      Código de subcomercio asignado por el FACILITADO a cada uno de sus subcomercios con espacios en blanco a la izquierda
  -----------------------------------------------------------------------------------------------------------------------------------------

Estructura secundaria. Principalmente transacciones con 3DS y Tokenizacion.

Contiene los campos dentro de trama.

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 28%" />
<col style="width: 29%" />
<col style="width: 12%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Orden</strong></th>
<th><strong>Campo Anterior</strong></th>
<th><strong>Subelemento</strong></th>
<th><strong>Longitud</strong></th>
<th><strong>Descripción</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>datoSeguridad3DS</td>
<td>Subelemento 43 datoSeguridad3DS (3–D Secure for Mastercard Identity Check)</td>
<td>32</td>
<td><p>(3–D Secure for Mastercard Identity Check)</p>
<p>Contiene los datos UCAF, esta descrita para la implementación de Mastercard 3DS.</p></td>
</tr>
<tr class="even">
<td>2</td>
<td>indicadorSeguridad3DS</td>
<td>Subelemento 42 indicadorSeguridad3DS (Electronic Commerce Indicators)</td>
<td>7</td>
<td>Contiene un indicador de comercio electrónico</td>
</tr>
<tr class="odd">
<td>3</td>
<td>idProtocolo3DS</td>
<td>Subelemento 66 idProtocolo3DS</td>
<td>16</td>
<td><p>Datos Adicionales para uso Privado.</p>
<p>Protocolo de Programa</p></td>
</tr>
<tr class="even">
<td>4</td>
<td>idTransaccionMastercard3DS</td>
<td>Subelemento 66 idTransaccionMastercard3DS</td>
<td>40</td>
<td><p>Datos Adicionales para uso Privado.</p>
<p>Id Transacción</p></td>
</tr>
<tr class="odd">
<td>5</td>
<td>tRID (no existente / referencial)</td>
<td>Subelement 33 (Token Requestor ID)</td>
<td>19</td>
<td><p>Nuevo Campo para Token Required ID</p>
<p>Identificación de Quien Solicita el Token) contienen la Identificación asignada por el Proveedor de Servicios de Token a Quien Solicita el Token (Token Requestor ID). Aplica para MasterCard y Visa</p></td>
</tr>
<tr class="even">
<td>6</td>
<td>tAVV (no existente / referencial)</td>
<td>Subelemneto 44 (Token Authentication Verification Value (TAVV))</td>
<td>24</td>
<td><p>Nuevo Campo para TAVV</p>
<p>44 (Identificador de Transaccion de Comercio Electronico 3-D Secure [XID][Visa y American Express]) contiene el identificador de transacciones de comercio Electronico 3-D Secure (XID).</p></td>
</tr>
</tbody>
</table>

El orden de campos y sus valores concatenados sin espacios se expresan así:

datoSeguridad3DS+indicadorSeguridad3DS+idProtocolo3DS+idTransaccionMastercard3DS+tRID+tAVV

Ejemplo campo datoSeguridad3DS (DE 48.43): 43205, donde.

  -----------------------------------------------------------------------
  43               Element ID
  ---------------- ------------------------------------------------------
  2                Longitud elemento

  an-2             Representación

  05               Valor
  -----------------------------------------------------------------------

Ejemplo campo indicadorSeguridad3DS (DE 48.42): 42205, donde.

  -----------------------------------------------------------------------
  42               Element ID
  ---------------- ------------------------------------------------------
  2                Longitud elemento

  an-2             Representación

  05               Valor
  -----------------------------------------------------------------------

Ejemplo campo idProtocolo3DS (DE 48.66.01): 6650121, donde.

<table>
<colgroup>
<col style="width: 64%" />
<col style="width: 35%" />
</colgroup>
<thead>
<tr class="header">
<th>66</th>
<th>Element ID</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>5</td>
<td>Longitud elemento</td>
</tr>
<tr class="even">
<td>01</td>
<td>Subcampo</td>
</tr>
<tr class="odd">
<td>2</td>
<td>Longitud elemento</td>
</tr>
<tr class="even">
<td>an-1</td>
<td>Representación</td>
</tr>
<tr class="odd">
<td><p>1 = 3–D Secure Version 1.0 (3DS 1.0)</p>
<p>2 = EMV 3–D Secure (3DS 2.0)</p></td>
<td>Valor</td>
</tr>
</tbody>
</table>

Ejemplo campo idTransaccionMastercard3DS (DE 48.66.02): 6602202, donde.

  -----------------------------------------------------------------------
  66                                               Element ID
  ------------------------------------------------ ----------------------
  02                                               Subcampo

  2                                                Longitud elemento

  ans-36                                           Representación

  f38e6948-5388-41a6-bca4-b49723c19437             Valor
  -----------------------------------------------------------------------

Ejemplo campo tRID (DE 48.33): ![](media/image7.png){width="1.3706780402449694in" height="0.16792979002624672in"}, donde.

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  33                                                                                                           Element ID
  ------------------------------------------------------------------------------------------------------------ ----------------------------------------
  16                                                                                                           Longitud elemento

  06                                                                                                           Subcampo

  11                                                                                                           Longitud elemento

  n-11                                                                                                         Representación

  ![](media/image8.png){width="0.6178958880139982in" height="0.14755686789151357in"}   Valor
  -----------------------------------------------------------------------------------------------------------------------------------------------------

Ejemplo campo tAVV (DE 48.44): 4420YmFzZTY0IGRlY29kZXI=, donde.

  -----------------------------------------------------------------------
  44                                     Element ID
  -------------------------------------- --------------------------------
  20                                     Longitud elemento

  b-20                                   Representación

  YmFzZTY0IGRlY29kZXI=                   Valor
  -----------------------------------------------------------------------

#### 4.3.3.2. Campo montosAdicionales {#campo-montosadicionales .unnumbered}

Campo destinado para montos en formato trama.

Tipo de campos:

  ------------------------------------------------------------------------
  Valor u Orden      Campo               Longitud      Ejemplo
  ------------------ ------------------- ------------- -------------------
  1                  IVA                 12            000000000125

  2                  Servicio            12            000000001256

  3                  Propina             12            000000000001

  4                  Intereses           12            000000000012

  5                  \# Autorización     06            000023

  6                  Monto Fijo          12            000000000658
  ------------------------------------------------------------------------

El orden de campos y sus valores concatenados sin espacios respetando el orden, teniendo así:

IVA+Servicio+Propina+Intereses+# Autorización+Monto Fijo

Ejemplo solo iva: 0161112000000000652, donde.

  -----------------------------------------------------------------------
  016                       longitud total
  ------------------------- ---------------------------------------------
  1                         cantidad de campos a recibir

  1                         tipo de campo: iva

  12                        longitud

  000000000652              valor
  -----------------------------------------------------------------------

Ejemplo iva + monto interés: 0222112000000000652440150, donde.

  -----------------------------------------------------------------------
  022                      longitud total
  ------------------------ ----------------------------------------------
  2                        cantidad de campos a recibir

  1                        tipo de campo: iva

  12                       longitud

  000000000652             valor

  4                        tipo de campo: interes

  4                        longitud

  0150                     valor
  -----------------------------------------------------------------------

#### 4.3.3.3. Campo informacionProductos {#campo-informacionproductos .unnumbered}

Campo destinado a información de productos en específico tipo de crédito, teniendo así.

  ---------------------------------------------------------------------------
  Valor u Orden   Identificador                               Longitud Fija
  --------------- ------------------------------------------- ---------------
  000             Transacción Corriente                       03

  001             Crédito Corriente                           03

  002             Crédito con Interés                         03

  003             Crédito sin Interés                         03

  004             Monto Fijo / Tipo de Comercio Gasolineras   03

  005             Promociones                                 03

  006             Tarjeta Propietaria                         03

  007             Tipo de crédito especial con interés        03

  008             Tarjeta descuento                           03

  009             Tipo de crédito especial sin interés        03

  021             Tipo de crédito plus cuotas                 03

  022             Tipo de crédito plus                        03

  101             Aereolíneas                                 03

  102             Tarjeta Inteligente                         03
  ---------------------------------------------------------------------------

Ejemplo tarjeta de débito: 00003001, donde.

  -----------------------------------------------------------------------
  000                   Idetificador del producto
  --------------------- -------------------------------------------------
  03                    Valor fijo

  001                   dato

  No aplica             Longitude total

  00003001              valor
  -----------------------------------------------------------------------

#### 4.3.3.4. Campo valoresAdicionales {#campo-valoresadicionales .unnumbered}

Campo destinado a información de valores adicionales, productos en específico de valor campo 58 con el identificador de campo 70 correspondiente a "**ID de Preautorización"**, teniendo así de manera general los campos asociados a valoresAdicionales.

  ----------------------------------------------------------------------------
  **Campo**                                                **Identificador**
  -------------------------------------------------------- -------------------
  Campo de Cedula                                          1

  Campo de Bitácora                                        2

  Campo de Cod comercio                                    3

  Campo de Cod cierre                                      4

  Campo de Teléfono                                        5

  Campo de Factura                                         6

  Campo de Puntos                                          7

  Campo de Celular                                         8

  Campo de Numero de Lote                                  9

  Campo de CI Vendedor(cedula)                             10

  Campo de Código vendedor                                 11

  Campo de Código comercio                                 12

  Campo de CI Vendedor Gas                                 13

  Campo de Vendedor                                        14

  Campo de PC Vendedor                                     15

  Campo de BG Vendedor                                     16

  Campo de Numero Cupon                                    17

  Campo de Cod Empleado                                    18

  Campo de ID Vendedor                                     19

  Campo de IVA                                             21

  Campo de ICE                                             22

  Campo de Impuesto                                        23

  Campo de Placa                                           24

  Campo de Otros                                           25

  Campo de Tarjeta                                         26

  Campo de Total Descuento                                 27

  Campo AD1                                                63

  Campo AD2                                                64

  Identificador de Proveedor de servicio                   66

  Identificador de Interfaz fijo para OTT Pacifico (006)   67

  ID Billetera (Diners)                                    68

  ID de Preautorizacion                                    70

  Identificador de recurrencia Boton                       75

  ID QR Billetera                                          79

  Correo voucher digital                                   80

  Identificador de tokenización Boton                      81

  Telefono de Subcomercio - Facilitador                    82

  Dirección de Subcomercio - Facilitador                   83

  Porcentaje de IVA de las Bases imponibles                84

  Identificador de RequestID (TAG 9F19)                    85

  Identificador de Agregador                               90

  Identificador de tipo de tarjeta (Geopagos FP)           92

  RED de Pos Ecuador (DATAFAST 99 (reservado BdP)          99
  ----------------------------------------------------------------------------

Para crear el campo tenemos la siguiente tabla de orden, longitudes y concatenación.

  ------------------------------------------------------------------------
  1      Longitud total                                             3
  ------ ---------------------------------------------------------- ------
  2      Longitud de los datos del campo                            2

  3      Identificador del campo                                    2

  4      Datos o Valor                                              
  ------------------------------------------------------------------------

Ejemplo: valoresAdicionales: "0281282099089120512104578124578", donde.

Los campos concatenados sin espacios y respetando sus longitudes tenemos.

LongitudTotal+(LongitudSumaIdentificadorCampo+LongDato)+IdentificadorCampo+Dato

028 = Longitud total del campo valoresAdicionales.

12 = Suma del identificador de campo + dato

82 = (Teléfono): identificador de campo

0990891205 = Dato o valor

12 = Suma del identificador de campo + dato

10 = (Cédula): identificador de campo

4578124578: = Dato o valor

Ejemplo tarjeta de débito: 00003001, donde.

  -----------------------------------------------------------------------
  000                   Idetificador del producto
  --------------------- -------------------------------------------------
  03                    Valor fijo

  001                   dato

  No aplica             Longitude total

  00003001              valor
  -----------------------------------------------------------------------

#### 4.3.3.5. Campo datosPOS {#campo-datospos .unnumbered}

Campo destinado a información de valores adicionales, productos en específico de valor campo 61 con el subcampo 7 correspondiente a "I**ndicador Status transacción"** accediendo al valor 4 correspondiente a **"Preautorizaciones"**.

  -------------------------------------------------------------------------------------------------------------------------------------------
  **Subcampo**                            **Posición**   **Atributo**   **Valor**
  --------------------------------------- -------------- -------------- ---------------------------------------------------------------------
  1 Indicador atención Terminal           1              n=1            Terminal Atendida por operador

                                                                        Terminal manejada por Tarjeta habiente

                                                                        No se usa terminal, (audiorespuesta etc)

                                                                        Información no disponible

  2 Capacidad de entrada de la terminal   2              n=1            0 No usado (POS)

                                                                        8 Contactless Proximity-Read-Capable terminal

  3 Indicador ubicación Terminal          3              N=1            0 En oficinas de Comercio

                                                                        1 Ubicación remota Comercio

                                                                        2 En oficina Tarjetahabiente (PC usuario)

                                                                        3 No se usa terminal

                                                                        6 Sin presencia Tarjetahabiente

                                                                        9 Información no disponible

  4 Indicador presencia Tarjetahabiente   4              N=1            0 Tarjetahabiente presente

                                                                        1 Tarjetahabiente no presente

                                                                        2 Tarjetahabiente no presente (orden correo)

                                                                        3 Tarjetahabiente no presente (Audiorespuesta)

                                                                        4 Transacciones recurrentes preautorizadas

                                                                        5 Tarjetahabiente no presente (Internet)

                                                                        9 Información no disponible

  5 Indicador presencia Tarjeta           5              N=1            0 Tarjeta presente

                                                                        1 Tarjeta no presente

                                                                        9 Información no disponible

  6 Indicador retención Tarjeta           6              N=1            0 El Operador o la terminal no tienen capacidad de retener tarjetas

                                                                        1 El Operador o la terminal tienen capacidad de retener tarjetas

                                                                        9 Información no disponible

  7 Indicador Status transacción          7              N=1            0 Transacción normal

                                                                        1 Compra aprobada por comercio

                                                                        3 Pago preautorizado recurrente

                                                                        4 Preautorización

                                                                        5 Standin Mastercard débito

                                                                        7 Compra con vueltas

  8 Indicador Seguridad Transacción       8              N=1            0 Sin problemas de seguridad

                                                                        1 Sospechoso de fraude

                                                                        2 Identificación verificada

  9                                       9              N=1            0 No usado

  10 Terminal type                        10             N=1            0 No es un CAT

                                                                        1 ATM o máquina dispensadora con PIN

                                                                        2 Terminal de autoservicio

                                                                        3 Terminal de cantidad limitada

                                                                        4 Comercio de aerolínea

                                                                        5 Dispositivo script

                                                                        6 Comercio Electrónico

                                                                        7 Transponder

                                                                        8 Mobile acceptance solution (Visa -- SoftPOS)

  11 Tipo lector Terminal                 11             N=1            0 Desconocido

                                                                        1 No se usa terminal

                                                                        2 Lector de banda

                                                                        3 Lector de Proximidad CHIP Contactless

                                                                        4 Lector de Proximidad Banda

                                                                        5 Lector banda y CHIP

                                                                        6 Teclado únicamente

                                                                        7 Lector banda y teclado

                                                                        8 Lector banda y chip, y teclado

                                                                        8 Contactless Proximity-Read-Capable Terminal (Visa -- SoftPOS)

                                                                        9 Lector CHIP

  12 Indicador ciclo autorización         dic-13         N=2            Número de días de preautorización

  13 Código País                          14-16          N=3            Código del País donde está ubicado el terminal

  14 Código Postal                        17-26          Ans-10         Código Postal de ubicación del terminal, ceros si se desconoce
  -------------------------------------------------------------------------------------------------------------------------------------------

Para crear el campo tenemos la siguiente tabla de orden, longitudes y concatenación.

  ------------------------------------------------------------------------
  1        Longitud total                                         3
  -------- ------------------------------------------------------ --------
  3        Identificador del campo                                2

  4        Datos o Valor                                          
  ------------------------------------------------------------------------

Ejemplo: datosPos con Preautoriaciones: "0000004000000218", donde.

  ----------------------------------------------------------------------------------------------
  Subcampo/ Posición   1   2   3   4   5   6   7   8   9   10   11   12   13    14
  -------------------- --- --- --- --- --- --- --- --- --- ---- ---- ---- ----- ----------------
  Valor                0   0   0   0   0   0   4   0   0   0    0    0    0     218

  ----------------------------------------------------------------------------------------------

#### 4.3.3.6. Campo nombreEstablecimiento {#campo-nombreestablecimiento .unnumbered}

El campo está compuesto por los siguientes sub campos:

-   Nombre de comercio: Largo 22

-   Espacio: Largo 1

-   Código de ciudad (Ej. GYE): Largo 13 (Si hiciera falta rellenar con espacios)

-   Espacio: Largo 1

-   Código de país: Largo 3

#### 4.3.3.7. Campo datosOriginales {#campo-datosoriginales .unnumbered}

Se concatena de la siguiente manera (no lleva separadores):

mensajeId+ fechaHoraTrasmision + numeroSeguimientoAuditoria+ idDatafast+ idEmisor

-   Autorización: Se envía cero (0)

> Ejemplo: 0

-   Anulación: Se concatena en base a la indicación inicial

Ejemplo: 020014051301012309080000047329300000473293

0200 + 1405130101 + 230908 + 00000473293 + 00000473293

Donde:

0200 -\> mensajeId: Largo 4 (Anulación)

1405130101 -\> fechaHoraTransmision: Largo 10

230908 -\> numeroSeguimientoAuditoria: Largo 6

00000473293 -\> idDatafast: Largo 11

00000473293 -\> idEmisor: Largo 11

Para formar el request de la anulación de una preautorizacion tomar en cuenta:

El campo datosOriginales, se forma concatenando los siguientes datos

\- 0200

\- CAMPO 11 (numeroSeguimientoAuditoria) de autorización original

\- CAMPO 7 (fechaHoraTransmision) de autorización original

\- CAMPO 32 (idDatafast) de autorización original

\- CAMPO 33 (idEmisor) de autorización original

Para formar el request de la anulación de un incremento tomar en cuenta:

El campo datosOriginales, se forma concatenando los siguientes datos

\- 0200

\- CAMPO 11 (numeroSeguimientoAuditoria) del incremento

\- CAMPO 7 (fechaHoraTransmision) del incremento

\- CAMPO 32 (idDatafast) del incremento

\- CAMPO 33 (idEmisor) del incremento

#### 4.3.3.8. Campo valorCampo61 {#campo-valorcampo61 .unnumbered}

Para preautorizaciones se requiere los valores de los campos marcados en rojo, los demás valores deberán ser 0.

Ejemplo: 000000400000218

![](media/image9.png){width="5.021527777777778in" height="5.936111111111111in"}

![](media/image10.png){width="5.028472222222222in" height="3.247916666666667in"}
