function fn() {
  var System = Java.type('java.lang.System');

  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  // Busca cada dato en este orden: comando de ejecucion, variables del equipo y valor de respaldo.
  var value = function (propertyName, environmentName, defaultValue) {
    var propertyValue = System.getProperty(propertyName);
    if (propertyValue !== null && propertyValue.trim() !== '') {
      return propertyValue;
    }

    var environmentValue = System.getenv(environmentName);
    return environmentValue !== null && environmentValue.trim() !== ''
      ? environmentValue
      : defaultValue;
  };

  // Carga las listas locales de comercios y tarjetas usadas por las pruebas.
  var env = value('karate.env', 'KARATE_ENV', 'cal');
  var merchants = karate.read('classpath:test-data/local/merchants.json').merchants;
  var cards = karate.read('classpath:test-data/local/cards.json');
  var merchantId = value('merchantId', 'MERCHANT_ID', 'cal-default');
  // La seleccion puede hacerse por perfil, numero o estado. Si no se informa,
  // se aplican las reglas de respaldo de abajo.
  var requestedCardProfile = value('cardProfile', 'CARD_PROFILE', '');
  var requestedCardNumber = value('cardNumber', 'CARD_NUMBER', '');
  var requestedCardStatus = value('cardStatus', 'CARD_STATUS', '');
  var selectedMerchant = merchants[0];
  // Karate conserva esta variable cuando una ejecucion anidada ya selecciono la tarjeta.
  var selectedCard = karate.get('selectedCard');

  // Busca el comercio elegido. Si no se indica uno, usa el primero de la lista.
  for (var index = 0; index < merchants.length; index++) {
    if (merchants[index].id === merchantId) {
      selectedMerchant = merchants[index];
      break;
    }
  }

  // Seleccion de tarjeta, en orden de prioridad:
  // 1) reutiliza la tarjeta ya seleccionada en la ejecucion;
  // 2) busca el perfil solicitado;
  // 3) busca el numero solicitado;
  // 4) busca el estado solicitado;
  // 5) sin selector, elige una tarjeta approved.
  // Un selector explicito que no existe detiene la ejecucion para evitar datos equivocados.
  if (!selectedCard) {
    if (requestedCardProfile !== '') {
      for (var profileCardIndex = 0; profileCardIndex < cards.length; profileCardIndex++) {
        if (cards[profileCardIndex].profileName === requestedCardProfile) {
          selectedCard = cards[profileCardIndex];
          break;
        }
      }

      if (!selectedCard) {
        throw new Error('Perfil de tarjeta no encontrado: ' + requestedCardProfile);
      }
    }

    if (!selectedCard && requestedCardNumber !== '') {
      for (var cardIndex = 0; cardIndex < cards.length; cardIndex++) {
        if (cards[cardIndex].cardNumber === requestedCardNumber) {
          selectedCard = cards[cardIndex];
          break;
        }
      }

      if (!selectedCard) {
        throw new Error('Tarjeta no encontrada: ' + requestedCardNumber);
      }
    }

    if (!selectedCard && requestedCardStatus !== '') {
      for (var statusCardIndex = 0; statusCardIndex < cards.length; statusCardIndex++) {
        if (cards[statusCardIndex].status === requestedCardStatus) {
          selectedCard = cards[statusCardIndex];
          break;
        }
      }

      if (!selectedCard) {
        throw new Error('Estado de tarjeta sin perfiles disponibles: ' + requestedCardStatus);
      }
    }

    if (!selectedCard && cards.length > 0) {
      for (var approvedCardIndex = 0; approvedCardIndex < cards.length; approvedCardIndex++) {
        if (cards[approvedCardIndex].status === 'approved') {
          selectedCard = cards[approvedCardIndex];
          break;
        }
      }

      if (!selectedCard) {
        throw new Error('No existe una tarjeta aprobada en el catalogo');
      }
    }

    if (selectedCard) {
      karate.set('selectedCard', selectedCard);
      karate.log('Tarjeta seleccionada para esta ejecución: ' + JSON.stringify({
        maskedCard: selectedCard.maskedCard,
        expirationDate: selectedCard.expirationDate,
        profileName: selectedCard.profileName,
        brand: selectedCard.brand,
        issuerCode: selectedCard.issuerCode,
        status: selectedCard.status
      }));
    }
  }

  // La tarjeta seleccionada es la fuente de cardNumber, maskedCard, cvv y metadata
  // para todos los features. Solo expirationDate puede sobrescribirse por comando.
  // Convierte la fecha del catalogo de MM/YY al formato del servicio YYMM.
  var configuredExpirationDate = value('expirationDate', 'EXPIRATION_DATE', '');
  var expirationDate = configuredExpirationDate;
  if (!expirationDate && selectedCard && selectedCard.expirationDate) {
    var expirationParts = selectedCard.expirationDate.split('/');
    expirationDate = expirationParts[1] + expirationParts[0];
  }

  var config = {
    env: env,
    baseUrl: value('baseUrl', 'BASE_URL', 'http://10.10.176.150:8299'),
    rsaPublicKeyPath: value(
      'rsaPublicKeyPath',
      'RSA_PUBLIC_KEY_PATH',
      '/seguridad/cal/canales/llaves-publicas/consulta'
    ),
    aplicacionId: value('aplicacionId', 'APLICACION_ID', 'PTP'),
    canalId: value('canalId', 'CANAL_ID', 'IN'),
    generarOtpPath: value(
      'generarOtpPath',
      'GENERAR_OTP_PATH',
      '/placetopay/calidad/seguridad/v1/otp-boton/generar'
    ),
    validarOtpPath: value(
      'validarOtpPath',
      'VALIDAR_OTP_PATH',
      '/placetopay/calidad/seguridad/v1/otp-boton/validar'
    ),
    tiposCreditoPath: value(
      'tiposCreditoPath',
      'TIPOS_CREDITO_PATH',
      '/placetopay/calidad/tarjetas/v1/parametros-autorizacion/formaspagos/consultar'
    ),
    calcularInteresPath: value(
      'calcularInteresPath',
      'CALCULAR_INTERES_PATH',
      '/placetopay/calidad/tarjetas/v1/parametros-autorizacion/interes/calcular'
    ),
    autorizarConsumoPath: value(
      'autorizarConsumoPath',
      'AUTORIZAR_CONSUMO_PATH',
      '/placetopay/calidad/consumos/pos/autorizar'
    ),
    publicKeyBase64: value('publicKeyBase64', 'PUBLIC_KEY_BASE64', ''),
    cardNumber: selectedCard ? selectedCard.cardNumber : requestedCardNumber,
    maskedCard: selectedCard ? selectedCard.maskedCard : value('maskedCard', 'MASKED_CARD', ''),
    expirationDate: expirationDate,
    cvv: selectedCard ? selectedCard.cvv : value('cvv', 'CVV', ''),
    cardProfile: selectedCard ? selectedCard.profileName : value('cardProfile', 'CARD_PROFILE', ''),
    cardBrand: selectedCard ? selectedCard.brand : value('cardBrand', 'CARD_BRAND', ''),
    issuerCode: selectedCard ? selectedCard.issuerCode : value('issuerCode', 'ISSUER_CODE', ''),
    cardStatus: selectedCard ? selectedCard.status : value('cardStatus', 'CARD_STATUS', ''),
    merchantId: merchantId,
    merchantCode: value('merchantCode', 'MERCHANT_CODE', selectedMerchant.merchantCode),
    actividadComercial: selectedMerchant.actividadComercial,
    nombreEstablecimiento: selectedMerchant.nombreEstablecimiento,
    matrixId: value('matrixId', 'MATRIX_ID', '1'),
    creditGroup: value('creditGroup', 'CREDIT_GROUP', 'C'),
    creditType: value('creditType', 'CREDIT_TYPE', '00'),
    installments: value('installments', 'INSTALLMENTS', '1'),
    transactionAmount: value('transactionAmount', 'TRANSACTION_AMOUNT', '500'),
    otp: value('otp', 'OTP', '000000'),
    profile: value('profile', 'PROFILE', 'S'),
    transactionCode: value('transactionCode', 'TRANSACTION_CODE', 'PTP')
  };

  return config;
}
