package pt.ulusofona.orderservice.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sqs.SqsClient;

@Configuration
public class SqsConfig {

    @Value("${aws.region:eu-west-1}")
    private String awsRegion;

    @Bean
    public SqsClient sqsClient() {
        // Usa automaticamente as credenciais do IAM Role da EC2 — sem chaves hardcoded!
        return SqsClient.builder()
                .region(Region.of(awsRegion))
                .build();
    }
}
