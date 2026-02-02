package com.global.hms.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.annotations.servers.Servers;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "HMS",
                version = "1.0.1",
                description = "Hospital Management System API",
        contact = @Contact (
                name = "",
                email = "",
                url = ""
            )
        ),
        servers = {
                @Server (
                        url = "http://localhost:8080",
                        description = ""
                ),
                @Server (
                        url = "",
                        description = ""
                )
        }
//        security = @SecurityRequirement(name = "bearerAuth")
    )
    @SecurityScheme(
            name = "",
            description = "",
            scheme = "",
            type = SecuritySchemeType.HTTP,
            bearerFormat = "",
            in = SecuritySchemeIn.HEADER
    )
@Profile("dev")
public class SwaggerConfig {

    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
                .group("public")
                .pathsToMatch("/api/auth/**")
                .build();
    }

    @Bean
    public GroupedOpenApi patientsApi() {
        return GroupedOpenApi.builder()
                .group("patients")
                .pathsToMatch("/api/patients/**")
                .build();
    }

    @Bean
    public GroupedOpenApi appointmentsApi() {
        return GroupedOpenApi.builder()
                .group("appointments")
                .pathsToMatch("/api/appointments/**")
                .build();
    }

    @Bean
    public GroupedOpenApi ipdApi() {
        return GroupedOpenApi.builder()
                .group("ipd")
                .pathsToMatch("/api/ipd/**")
                .build();
    }

    @Bean
    public GroupedOpenApi labApi() {
        return GroupedOpenApi.builder()
                .group("lab")
                .pathsToMatch("/api/lab/**")
                .build();
    }

    @Bean
    public GroupedOpenApi billingApi() {
        return GroupedOpenApi.builder()
                .group("billing")
                .pathsToMatch("/api/billing/**")
                .build();
    }

    @Bean
    public GroupedOpenApi allApi() {
        return GroupedOpenApi.builder()
                .group("all")
                .pathsToMatch("/api/**")
                .build();
    }
}
