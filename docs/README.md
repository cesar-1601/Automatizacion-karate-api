# Documentacion de automatizacion con Karate DSL

## 1. Objetivo

Este proyecto automatizara el flujo de calidad para Place To Pay usando Karate DSL, Java 21 y Maven.

El flujo principal contempla:

1. Consultar la llave RSA publica.
2. Consultar tipos de credito.
3. Calcular interes.
4. Generar y validar OTP.
5. Autorizar consumo.

El OTP de calidad se considera `000000` cuando el endpoint de validacion OTP sea incluido en la ejecucion.

## 2. Requisitos locales

Instalar y verificar:

- Java JDK 21.
- Maven 3.9 o superior.
- Visual Studio Code.
- Extension Pack for Java para VS Code.
- Acceso de red o VPN al ambiente CAL.
- Datos dummy autorizados.

Comandos de verificacion:

```powershell
java -version
mvn -version
```

La salida de Java debe indicar version 21.

## 3. Estructura esperada

```text
automatizacion-karate/
├── pom.xml
├── karate-config.js
├── test-data/
│   └── local/
│       ├── cards.json
│       └── merchants.json
├── docs/
│   └── README.md
└── src/
    └── test/
        ├── java/
        │   └── com/dinersclub/integracion/
        │       ├── CryptoUtils.java
        │       ├── EndpointTest.java
        │       ├── FlujoAprobadoTest.java
        │       └── EscenariosNegativosTest.java
        └── resources/
            └── features/
                ├── base-request.js
                ├── crypto-request.js
                ├── consultar-llave-rsa-publica.feature
                ├── consultar-tipos-credito.feature
                ├── calcular-interes.feature
                ├── generar-otp.feature
                ├── validar-otp.feature
                ├── autorizar-consumo.feature
                ├── flujo-completo.feature
                ├── escenarios-negativos.feature
                └── escenarios-flujo.feature
            └── test-data/
                └── negative-scenarios.json
```

## 4. Ambiente CAL

Configuracion base:

```text
baseUrl: http://10.10.176.150:8299
aplicacionId: PTP
canalId: IN
```

Endpoints:

```text
POST /seguridad/cal/canales/llaves-publicas/consulta
POST /placetopay/calidad/seguridad/v1/otp-boton/generar
POST /placetopay/calidad/seguridad/v1/otp-boton/validar
POST /placetopay/calidad/tarjetas/v1/parametros-autorizacion/formaspagos/consultar
POST /placetopay/calidad/tarjetas/v1/parametros-autorizacion/interes/calcular
POST /placetopay/calidad/consumos/pos/autorizar
```

La ruta de autorizacion debe confirmarse con infraestructura. La documentacion tambien registra la ruta alternativa:

```text
/placetopay/calidad/tarjetas/v1/consumos/autorizar
```

## 5. Headers obligatorios

Cada request debe incluir:

```text
Content-Type: application/json
x-aplicacion-id: PTP
x-canal-id: IN
```

## 6. Cifrado requerido

El formato actual utiliza criptografia hibrida:

- AES-256-GCM para los campos sensibles.
- AES-256-GCM para el body completo.
- RSA-2048 para cifrar la llave AES.

Para AES-GCM:

- Llave de 32 bytes.
- IV aleatorio de 12 bytes.
- Tag de autenticacion de 16 bytes.
- Resultado transmitido como `Base64(IV + ciphertext + tag)`.

Para cada request se deben usar llaves e IV nuevos. No se deben mezclar `body` y `secretKey` provenientes de ejecuciones distintas.

El valor de `secretKey` debe contener la llave AES del body cifrada con RSA. El IV del body ya viaja dentro del valor GCM; no se concatena al `secretKey`.

## 7. Datos de prueba

No usar tarjetas reales. Se necesitan datos dummy habilitados por el ambiente:

- Numero de tarjeta.
- Fecha de expiracion.
- CVV.
- Tarjeta enmascarada.
- Codigo de comercio.
- Terminal y datos POS autorizados.
- OTP de calidad: `000000`, si el ambiente lo tiene configurado de esa forma.

La llave publica RSA puede recibirse desde el endpoint de consulta o configurarse manualmente como variable de ejecucion. No guardar llaves privadas en el repositorio.
Los datos locales de tarjetas y comercios se mantienen en `test-data/local/cards.json`
y `test-data/local/merchants.json`; estos archivos no se versionan. El catálogo
compartible de casos negativos está en `src/test/resources/test-data/negative-scenarios.json`
y contiene la configuración de cada caso
(`cardProfile`, overrides y resultado esperado); no contiene la logica del flujo.
El comercio se selecciona mediante `MERCHANT_ID` y
el comercio seleccionado expone su `merchantCode` a los features.
Cuando `CARD_NUMBER` coincide con una tarjeta de `cards.json`, la fecha de expiracion
se completa automaticamente y se convierte de `MM/YY` a `YYMM`. El `CVV` tambien
se toma del catalogo local para la tarjeta seleccionada. Los valores de tarjeta
seleccionada tienen prioridad sobre `MASKED_CARD` y `CVV`; la fecha puede
sobrescribirse mediante `EXPIRATION_DATE`.
Cada tarjeta puede definir `profileName`, `brand`, `issuerCode` y `status`. El
catalogo contiene perfiles como `diners-approved`, `diners-declined` y
`diners-expired`. En `escenarios-negativos.feature`, el perfil de cada escenario
se resuelve desde `negative-scenarios.json`; por ello, la suite puede usar perfiles
diferentes en una misma ejecución y no depende de un único `-DcardProfile` global.
Los features individuales siguen aceptando selección por `cardProfile`, `cardNumber`
o `cardStatus`. Un selector explícito que no existe detiene la ejecución. Si
`MERCHANT_ID` no coincide, se usa el primer comercio del catálogo; verifica el log
de tarjeta enmascarada antes de una ejecución destructiva.

## 8. Variables de ejecucion

En este proyecto, la ejecucion se dispara con la propiedad `-Dfeature`, que es leida por
[EndpointTest.java](../src/test/java/com/dinersclub/integracion/EndpointTest.java).

### Ejecutar un feature concreto en PowerShell

```powershell
cd "c:\Users\SOFK115221\Documents\automatizacion-karate"
& "C:\apache-maven-3.9.16\bin\mvn.cmd" -Dfeature=flujo-completo test
```

También se puede ejecutar el conjunto de escenarios end-to-end en flujo integrado:

```powershell
cd "c:\Users\SOFK115221\Documents\automatizacion-karate"
& "C:\apache-maven-3.9.16\bin\mvn.cmd" -Dfeature=escenarios-flujo test
```

> En PowerShell es necesario usar `&` antes de `mvn.cmd` para invocar el ejecutable correctamente.

Los valores reales deben ser proporcionados por el equipo responsable del ambiente CAL.
Los features cifrados intentan obtener automaticamente `publicKeyBase64` mediante
el servicio de consulta de llave cuando no se proporciona `-DpublicKeyBase64` o
`PUBLIC_KEY_BASE64`. No guardar tarjetas, CVV, OTP ni llaves privadas en el repositorio.
El archivo `.env.example` documenta nombres de variables, pero el proyecto no carga
automaticamente un archivo `.env`; se deben usar variables de entorno o propiedades
`-D` de Maven.

Para seleccionar un comercio definido en `test-data/local/merchants.json`:

```powershell
& "C:\apache-maven-3.9.16\bin\mvn.cmd" -Dfeature=consultar-tipos-credito -DmerchantId=cal-default test
```

`-DmerchantCode` o `MERCHANT_CODE` tiene prioridad sobre el valor del archivo y
permite sobrescribirlo para una ejecución puntual.

`TRANSACTION_AMOUNT` se envía en la unidad menor de la moneda, sin separador
decimal. Por ejemplo, `500` representa `$5.00` y `10000` representa `$100.00`.
Para una transacción de cinco dólares se debe usar `-DtransactionAmount=500`.

## 9. Orden de ejecucion recomendado

### 9.1 Consultar llave RSA publica

Es el primer paso del flujo porque la llave se utiliza para proteger las llaves AES
de los requests cifrados.

### 9.2 Consultar tipos de credito

Se valida que la tarjeta y el comercio permitan obtener las formas de pago o tipos de credito.

### 9.3 Calcular interes

Se usan los parametros devueltos o autorizados por la consulta anterior, junto con monto, tipo de credito y cuotas.

### 9.4 Generar y validar OTP

Se genera el OTP y se valida con el valor configurado mediante `-Dotp` o `OTP`; el
valor predeterminado es `000000`. El flujo actual no extrae un OTP desde la respuesta
de generacion. Si la validacion falla, el flujo no debe continuar hacia la autorizacion.

### 9.5 Autorizar consumo

Debe ejecutarse solamente con datos dummy y bajo autorizacion del ambiente, porque puede representar una operacion financiera.

### 9.6 Ejecutar el flujo completo

El feature `flujo-completo.feature` encadena la consulta de llave, tipos de credito,
interes, generacion/validacion de OTP y autorizacion. Tiene las etiquetas `@full-flow`
y `@destructive`; debe ejecutarse de forma controlada y solo con datos dummy autorizados.

La implementación compatible con los scripts GCM de DataPower usa
`RSA/ECB/PKCS1Padding` para cifrar las llaves AES.

## 10. Respuestas cifradas

### Origen de la respuesta y llave privada

La respuesta que recibe Karate llega desde **DataPower**, usando la URL del gateway
configurada en `baseUrl`. DataPower recibe la petición, la descifra y la enruta al
microservicio correspondiente en OpenShift. El microservicio procesa la operación y
genera la respuesta funcional; después DataPower cifra nuevamente el body y lo devuelve
a Karate.

Por esta razón, Karate no consulta directamente la respuesta en OpenShift. La respuesta
visible en el reporte o en la consola es la respuesta del gateway DataPower y normalmente
tiene los campos `body` y `secretKey`.

La llave privada necesaria para leer esa respuesta debe corresponder a la llave pública
de la pasarela que Diners registró previamente para el aplicativo y canal. No es una llave
privada de OpenShift ni se debe asumir que es una llave privada de DataPower. Debe ser el
par privado de la pasarela cliente, por ejemplo el par asociado a `PTP` e `IN`.

El flujo de llaves es diferente para cada dirección:

- Para enviar peticiones, Karate obtiene la llave pública de Diners mediante el endpoint
  de consulta y con ella cifra las llaves AES de la petición.
- Para recibir respuestas, Diners/DataPower usa la llave pública de la pasarela y Karate
  necesitaría la llave privada correspondiente para descifrar `secretKey`.

La llave privada no debe guardarse en el repositorio ni imprimirse en consola. Debe
proporcionarse mediante una ruta local protegida o un gestor seguro, y solo si el equipo
responsable confirma que pertenece al par registrado en CAL.

Las respuestas de DataPower pueden tener esta forma:

```json
{
  "body": "BASE64_CIFRADO",
  "secretKey": "BASE64_RSA"
}
```

La automatizacion actual valida la envoltura tecnica de la respuesta, pero aun no
descifra funcionalmente respuestas de DataPower. Para completar esa validacion se
necesita:

1. Descifrar `secretKey` con la llave privada RSA de la pasarela.
2. Obtener la llave AES de respuesta.
3. Descifrar `body` con AES-256-GCM.
4. Leer el JSON resultante y validar codigo, mensaje y detalle.

La llave privada debe permanecer local y nunca debe compartirse ni subirse al repositorio.

## 11. Ejecucion desde VS Code

Abrir en VS Code la carpeta:

```text
C:\Users\SOFK115221\Documents\automatizacion-karate
```

Desde la terminal integrada, `mvn test` ejecuta los runners separados del flujo
aprobado y de escenarios negativos:

```powershell
mvn test -Dkarate.env=cal
```

Para ejecutar un feature especifico mediante `EndpointTest`, use la propiedad
`feature`. En ese caso los runners separados se deshabilitan para evitar duplicar
la ejecucion:

```powershell
mvn test -Dfeature=consultar-llave-rsa-publica
mvn test -Dfeature=generar-otp
mvn test -Dfeature=validar-otp -Dotp=000000
mvn test -Dfeature=consultar-tipos-credito
mvn test -Dfeature=calcular-interes
mvn test -Dfeature=autorizar-consumo
mvn test -Dfeature=escenarios-flujo
```

Para ejecutar toda la suite de escenarios negativos:

```powershell
mvn -Dtest=EscenariosNegativosTest test
```

Para ejecutar un escenario negativo concreto, use su tag con `karate.options`.
El propio escenario selecciona su perfil desde `negative-scenarios.json`:

```powershell
mvn -Dtest=EscenariosNegativosTest "-Dkarate.options=--tags @TAG_DEL_ESCENARIO" test
```

Por ejemplo, para ejecutar el rechazo funcional de tarjeta vencida, use el tag
`@tarjeta-vencida`; ese caso selecciona `diners-expired` automáticamente.

Tambien puede ejecutar cada suite de forma aislada:

```powershell
mvn -Dtest=FlujoAprobadoTest test
```

Para ejecutar manualmente el flujo completo:

```powershell
mvn test -Dfeature=flujo-completo -Dkarate.env=cal
```

Los features cifrados requieren una tarjeta dummy, comercio y demás datos del
ambiente. Si no se proporciona `publicKeyBase64` o `PUBLIC_KEY_BASE64`, los features
intentan consultar la llave RSA automáticamente.

Los reportes de Karate normalmente quedan en:

```text
target\karate-reports\karate-summary.html
```

## 12. Convenciones de tags

Los tags permiten clasificar escenarios y seleccionar escenarios dentro de Karate.
La propiedad `-Dfeature` del runner selecciona el archivo; los tags no sustituyen
esa propiedad en la implementacion actual.

| Tag | Uso |
| --- | --- |
| `@smoke` | Prueba rapida y esencial para verificar disponibilidad basica. |
| `@positive` | Flujo exitoso esperado. |
| `@negative` | Rechazo, validacion de error o respuesta no exitosa esperada. |
| `@pendiente` | Escenario documentado, pero aun no implementado completamente. |
| `@manual` | Requiere ejecucion manual y autorizacion previa. |
| `@destructive` | Puede generar una operacion financiera o cambiar informacion. |
| `@llave-publica` | Consulta de la llave RSA publica. |
| `@crypto` | Cifrado o descifrado de datos. |
| `@otp` | Generacion o validacion de OTP. |
| `@credito` | Consulta de tipos de credito o formas de pago. |
| `@interes` | Calculo de interes y cuotas. |
| `@autorizar` | Autorizacion de consumo. |
| `@flujo` | Flujo que coordina varios servicios. |
| `@integracion` | Escenario que combina mas de un endpoint. |

Los escenarios con `@pendiente` contienen placeholders y no deben considerarse
pruebas terminadas. Los escenarios con `@manual` o `@destructive` no deben
ejecutarse automaticamente en cada compilacion; requieren datos dummy autorizados
y confirmacion del equipo responsable de CAL.

La autorizacion de consumo debe tratarse como una operacion controlada aunque el
escenario use datos dummy:

```gherkin
@manual @destructive @autorizar
Scenario: Autorizar consumo con datos dummy aprobados
```

## 13. Diagnostico rapido

- `self-signed certificate in certificate chain`: falta el certificado CA o se esta consultando una llave publica por HTTPS sin confianza TLS.
- `404 Not Found`: la ruta del endpoint no corresponde al gateway activo.
- `400 Campos incompletos`: faltan headers, `body`, `secretKey` o campos internos requeridos.
- `Error de descifrado`: se mezclo CBC con GCM, se uso otra llave publica o se mezclaron valores de ejecuciones distintas.
- `401/403`: aplicacion, canal o permisos no autorizados.
- Error de negocio: los datos dummy de tarjeta, comercio, terminal, CVV o expiracion no son validos para CAL.

## 14. Recomendaciones

- Mantener las pruebas de cifrado separadas de las pruebas contra CAL.
- No ejecutar autorizacion en cada commit.
- Usar `-D` o variables de entorno para cambiar CAL, GSF y otros ambientes.
- No guardar tarjetas, CVV, llaves privadas ni secretos en archivos versionados.
- Registrar respuestas funcionales sin exponer datos sensibles.
