package com.dinersclub.integracion;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(
    named = "feature",
    matches = ".+",
    disabledReason = "La ejecucion puntual usa EndpointTest"
)
class EscenariosNegativosTest {

    @Karate.Test
    Karate ejecutarEscenariosNegativos() {
        return Karate.run("classpath:features/escenarios-negativos.feature");
    }
}