function fn() {
  var now = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  now.setTimeZone(java.util.TimeZone.getTimeZone('UTC'));
  var transmission = new java.text.SimpleDateFormat('MMddHHmmss');
  var businessDate = new java.text.SimpleDateFormat('yyyyMMdd');
  var localDate = new java.text.SimpleDateFormat('MMdd');
  var localTime = new java.text.SimpleDateFormat('HHmmss');
  var uuid = function () { return java.util.UUID.randomUUID().toString(); };

  return {
    uuid: uuid,
    transactionData: function () {
      var date = new java.util.Date();
      var transmissionValue = transmission.format(date);
      return {
        date: businessDate.format(date),
        time: localTime.format(date),
        transmission: transmissionValue,
        audit: '99' + transmissionValue.substring(6),
        reference: '999999' + transmissionValue.substring(4),
        localDate: localDate.format(date),
        localTime: localTime.format(date)
      };
    },
    header: function (sessionId) {
      return {
        aplicacionId: aplicacionId,
        canalId: canalId,
        sesionId: '',
        dispositivo: 'ClienteJS',
        idioma: 'es',
        portalId: 'PIN',
        uuid: uuid(),
        ip: '127.0.0.1',
        horaTransaccion: now.format(new java.util.Date()),
        llaveSimetrica: '',
        usuario: 'testUser',
        paginado: { cantRegistros: 0, numTotalPag: 0, numPagActual: 0 },
        tags: [{ clave: '', valor: '' }]
      };
    },
    assertEncryptedResponse: function (response) {
      if (response.dinHeader && response.dinHeader.llaveSimetrica) {
        karate.match(response.dinBody, '#present');
      } else {
        karate.match(response.dinBody, '#present');
      }
    }
  };
}