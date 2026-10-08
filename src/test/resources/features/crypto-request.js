function fn() {
  var CryptoUtils = Java.type('com.dinersclub.integracion.CryptoUtils');
  var requirePublicKey = function () {
    if (!publicKeyBase64) {
      var rsaResult = karate.call('classpath:features/consultar-llave-rsa-publica.feature@llave-publica');
      if (rsaResult && rsaResult.response && rsaResult.response.dinBody && rsaResult.response.dinBody.llavePublica) {
        publicKeyBase64 = rsaResult.response.dinBody.llavePublica;
      } else {
        karate.fail('Falta publicKeyBase64/PUBLIC_KEY_BASE64. Ejecute primero la consulta de llave RSA o proporcione la llave del ambiente CAL.');
      }
    }
  };
  var encryptFields = function (values) {
    requirePublicKey();
    var fieldKey = CryptoUtils.generateAesKeyBase64();
    var encrypted = {};
    for (var name in values) {
      encrypted[name] = CryptoUtils.encryptGcm(String(values[name]), fieldKey);
    }
    return { values: encrypted, key: fieldKey };
  };
  var encryptBody = function (body, fieldKey, headerFieldKey, bodySecretKey) {
    requirePublicKey();
    var keyForHeader = headerFieldKey == null ? fieldKey : headerFieldKey;
    body.dinHeader.llaveSimetrica = CryptoUtils.encryptAesKeyWithRsa(keyForHeader, publicKeyBase64);
    var bodyKey = CryptoUtils.generateAesKeyBase64();
    var keyForSecret = typeof bodySecretKey === 'undefined' ? bodyKey : bodySecretKey;
    return {
      body: CryptoUtils.encryptGcm(JSON.stringify(body), bodyKey),
      secretKey: CryptoUtils.encryptAesKeyWithRsa(keyForSecret, publicKeyBase64),
      fieldSecretKey: CryptoUtils.encryptAesKeyWithRsa(fieldKey, publicKeyBase64)
    };
  };
  return { encryptFields: encryptFields, encryptBody: encryptBody };
}