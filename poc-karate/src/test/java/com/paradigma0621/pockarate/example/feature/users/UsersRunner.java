package com.paradigma0621.pockarate.example.feature.users;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class UsersRunner {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:com/paradigma0621/pockarate/example/feature")
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}
