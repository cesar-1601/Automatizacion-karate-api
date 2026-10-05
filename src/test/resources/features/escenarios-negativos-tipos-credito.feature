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

  # Casos pendientes de implementación para validación del contrato en tipos de crédito
  # @negativo @tipos-credito @tarjeta-no-encontrada
  # # Código esperado: 9994 - Tarjeta no encontrada
  # Scenario: Rechazar tarjeta no encontrada
  #   * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
  #   * def publicKeyBase64 = rsa.response.dinBody.llavePublica
  #   * def args = { publicKeyBase64: '#(publicKeyBase64)', cardNumber: '0000000000000000', expectedHttpStatus: 404 }
  #   * def response = call read('classpath:features/consultar-tipos-credito.feature') args
  #   * match response.responseStatus == args.expectedHttpStatus

  # @negativo @tipos-credito @aplicacion-id-obligatorio
  # # Código esperado: 9995 - El AplicacionId es Requerido
  # Scenario: Rechazar sin aplicacionId
  #   * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
  #   * def publicKeyBase64 = rsa.response.dinBody.llavePublica
  #   * def args = { publicKeyBase64: '#(publicKeyBase64)', omitAplicacionId: true, expectedHttpStatus: 400 }
  #   * def response = call read('classpath:features/consultar-tipos-credito.feature') args
  #   * match response.responseStatus == args.expectedHttpStatus

  # @negativo @tipos-credito @canal-id-obligatorio
  # # Código esperado: 9996 - El CanalId es Requerido
  # Scenario: Rechazar sin canalId
  #   * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
  #   * def publicKeyBase64 = rsa.response.dinBody.llavePublica
  #   * def args = { publicKeyBase64: '#(publicKeyBase64)', omitCanalId: true, expectedHttpStatus: 400 }
  #   * def response = call read('classpath:features/consultar-tipos-credito.feature') args
  #   * match response.responseStatus == args.expectedHttpStatus

  # @negativo @tipos-credito @descifrado-fallido
  # # Código esperado: 9997 - Error en el Descifrado de datos
  # Scenario: Rechazar cuando falla el descifrado
  #   * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
  #   * def publicKeyBase64 = rsa.response.dinBody.llavePublica
  #   * def args = { publicKeyBase64: '#(publicKeyBase64)', invalidSecretKey: true, expectedHttpStatus: 400 }
  #   * def response = call read('classpath:features/consultar-tipos-credito.feature') args
  #   * match response.responseStatus == args.expectedHttpStatus

  # @negativo @tipos-credito @cifrado-fallido
  # # Código esperado: 9998 - Error en el cifrado de datos
  # Scenario: Rechazar cuando falla el cifrado
  #   * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
  #   * def publicKeyBase64 = rsa.response.dinBody.llavePublica
  #   * def args = { publicKeyBase64: '#(publicKeyBase64)', invalidCipher: true, expectedHttpStatus: 400 }
  #   * def response = call read('classpath:features/consultar-tipos-credito.feature') args
  #   * match response.responseStatus == args.expectedHttpStatus

  # @negativo @tipos-credito @criptografia-fallida
  # # Código esperado: 9999 - Error en criptografía
  # Scenario: Rechazar cuando falla la criptografia
  #   * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
  #   * def publicKeyBase64 = rsa.response.dinBody.llavePublica
  #   * def args = { publicKeyBase64: '#(publicKeyBase64)', invalidCrypto: true, expectedHttpStatus: 500 }
  #   * def response = call read('classpath:features/consultar-tipos-credito.feature') args
  #   * match response.responseStatus == args.expectedHttpStatus
