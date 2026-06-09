package pt.ulusofona.orderservice.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import pt.ulusofona.orderservice.event.OrderCreatedEvent;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

@Service
@RequiredArgsConstructor
@Slf4j
public class SqsProducerService {

    private final SqsClient sqsClient;

    @Value("${aws.sqs.queue-url}")
    private String queueUrl;

    private final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    public void sendOrderCreatedEvent(OrderCreatedEvent event) {
        try {
            String messageBody = objectMapper.writeValueAsString(event);

            SendMessageRequest request = SendMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .messageBody(messageBody)
                    .build();

            sqsClient.sendMessage(request);
            log.info("OrderCreatedEvent enviado para SQS — order ID: {}", event.getOrderId());

        } catch (Exception e) {
            log.error("Falha ao enviar OrderCreatedEvent para SQS — order ID: {}: {}",
                    event.getOrderId(), e.getMessage());
            // Não falhamos a criação da encomenda se o SQS falhar
        }
    }
}
