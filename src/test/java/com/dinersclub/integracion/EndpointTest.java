package com.dinersclub.integracion;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Assumptions;

class EndpointTest {

    @Karate.Test
    Karate ejecutarFeatureSeleccionado() {
        Assumptions.assumeTrue(
            System.getProperty("feature") != null,
            "EndpointTest se usa para ejecuciones puntuales con -Dfeature"
        );

        // Permite elegir desde el comando que proceso se quiere probar.
        String feature = System.getProperty("feature");
        // Solo permite procesos conocidos y evita errores por nombres mal escritos.
        String featurePath = switch (feature) {
            case "consultar-llave-rsa-publica" -> "features/consultar-llave-rsa-publica.feature";
            case "consultar-tipos-credito" -> "features/consultar-tipos-credito.feature";
            case "calcular-interes" -> "features/calcular-interes.feature";
            case "generar-otp" -> "features/generar-otp.feature";
            case "validar-otp" -> "features/validar-otp.feature";
            case "autorizar-consumo" -> "features/autorizar-consumo.feature";
            case "flujo-completo" -> "features/flujo-completo.feature";
            case "escenarios-negativos" -> "features/escenarios-negativos.feature";
            case "escenarios-flujo" -> "features/escenarios-flujo.feature";
            default -> throw new IllegalArgumentException(
                "Feature no permitido: " + feature
                    + ". Valores: consultar-llave-rsa-publica, consultar-tipos-credito, "
                    + "calcular-interes, generar-otp, validar-otp, autorizar-consumo, "
                    + "flujo-completo, escenarios-negativos, escenarios-flujo"
            );
        };

        return Karate.run("classpath:" + featurePath);
    }
}