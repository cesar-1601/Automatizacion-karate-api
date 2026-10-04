Feature: Escenarios negativos de consulta de tipos de credito

  # Estos casos validan el contrato técnico del endpoint y no continúan al flujo.

  @negativo @tipos-credito @comercio-ausente
  # Código esperado: 0018 - El campo codigoComercio es obligatorio.
  Scenario: Rechazar consulta sin codigoComercio
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)', omitMerchantCode: true, expectedHttpStatus: 400 }
    * def response = call read('classpath:features/consultar-tipos-credito.feature') args
    * match response.responseStatus == args.expectedHttpStatus

  @negativo @tipos-credito @comercio-longitud
  # Código esperado: 0020 - La longitud de codigoComercio supera el máximo permitido.
  Scenario: Rechazar codigoComercio con mas de 10 caracteres
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)', merchantCodeOverride: '12345678901', expectedHttpStatus: 400 }
    * def response = call read('classpath:features/consultar-tipos-credito.feature') args
    * match response.responseStatus == args.expectedHttpStatus

  @negativo @tipos-credito @tarjeta-cifrada-ausente
  # Código esperado: 0019 - El campo tarjetaEncriptada es obligatorio.
  Scenario: Rechazar consulta sin tarjetaEncriptada
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)', omitEncryptedCard: true, expectedHttpStatus: 400 }
    * def response = call read('classpath:features/consultar-tipos-credito.feature') args
    * match response.responseStatus == args.expectedHttpStatus

  @negativo @tipos-credito @tarjeta-enmascarada-longitud
  # Código esperado: 0021 - La longitud de tarjetaEnmascarada supera el máximo permitido.
  Scenario: Rechazar tarjetaEnmascarada con mas de 22 caracteres
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)', maskedCardOverride: '***********************', expectedHttpStatus: 400 }
    * def response = call read('classpath:features/consultar-tipos-credito.feature') args
    * match response.responseStatus == args.expectedHttpStatus
