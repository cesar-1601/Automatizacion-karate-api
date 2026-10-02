Feature: Autorizar consumo

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * url baseUrl
    * path autorizarConsumoPath
    * header Content-Type = 'application/json'
    * header x-aplicacion-id = aplicacionId
    * header x-canal-id = canalId

  @autorizar @destructive @encrypted
  Scenario: Autorizar consumo con datos dummy autorizados
    * match cardNumber == '#string'
    * match cardNumber != ''
    * match expirationDate == '#string'
    * match expirationDate != ''
    * match cvv == '#string'
    * match cvv != ''
    * def fields = crypto.encryptFields({ tarjeta: cardNumber, expiracion: expirationDate, cvv: cvv })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def transactionData = base.transactionData()
    * def dinBody = { codigoRuteo: 'T', mensajeId: '0200', codigoTipoVia: '40', numeroTarjeta: '#(values.tarjeta)', codigoTransaccion: '003000', montoTransaccion: '#(transactionAmount)', fechaHoraTransmision: '#(transactionData.transmission)', numeroSeguimientoAuditoria: '#(transactionData.audit)', horaTransaccion: '#(transactionData.localTime)', fechaTransaccion: '#(transactionData.localDate)', fechaExpiracion: '#(values.expiracion)', fechaContable: '#(transactionData.localDate)', actividadComercial: '#(actividadComercial)', tipoLecturaPOS: '010', secuenciaNumeroTarjeta: '001', idDatafast: '01793206667', idEmisor: '00000473293', track2: '', numeroReferenciaTransaccion: '#(transactionData.reference)', numeroAprobacion: '', codigoRespuesta: '', idTerminalEstablecimiento: 'H0000437', idEstablecimiento: '#(merchantCode)', nombreEstablecimiento: '#(nombreEstablecimiento)', track1: '', codigoSeguridad: '#(values.cvv)', codigoMoneda: '840', pinBlock: '', montosAdicionales: '', circuitoIntegradoTarjeta: '', informacionProductos: '#(creditGroup + creditType + installments)', valoresAdicionales: '', datosPOS: '00000000003002180000000000', codigoAdministracionRedes: '', datosOriginales: '', codigoMensajeSeguridad: '', tagsAdministracionRedes: '', tarjetaEnmascarada: '#(maskedCard)' }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 200
    And match response.body == '#string'
    And match response.secretKey == '#string'