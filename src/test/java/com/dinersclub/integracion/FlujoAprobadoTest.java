package com.dinersclub.integracion;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(
    named = "feature",
    matches = ".+",
    disabledReason = "La ejecucion puntual usa EndpointTest"
)
class FlujoAprobadoTest {

    @Karate.Test
    Karate ejecutarFlujoAprobado() {
        return Karate.run("classpath:features/flujo-completo.feature");
    }
}