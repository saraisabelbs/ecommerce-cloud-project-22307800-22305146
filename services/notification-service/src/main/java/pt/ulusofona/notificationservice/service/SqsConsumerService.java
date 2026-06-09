package pt.ulusofona.notificationservice.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import pt.ulusofona.notificationservice.event.OrderCreatedEvent;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class SqsConsumerService {

    private final SqsClient sqsClient;

    @Value("${aws.sqs.queue-url}")
    private String queueUrl;

    private final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Scheduled(fixedDelayString = "${notification.polling.interval-ms:5000}")
    public void pollMessages() {
        try {
            ReceiveMessageRequest receiveRequest = ReceiveMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .maxNumberOfMessages(10)
                    .waitTimeSeconds(5) // long polling
                    .build();

            List<Message> messages = sqsClient.receiveMessage(receiveRequest).messages();

            for (Message message : messages) {
                processMessage(message);
            }

        } catch (Exception e) {
            log.error("Error polling SQS: {}", e.getMessage());
        }
    }

    private void processMessage(Message message) {
        try {
            OrderCreatedEvent event = objectMapper.readValue(message.body(), OrderCreatedEvent.class);

            // In a real system this would send an email. For this project we log it.
            log.info("=== NEW ORDER NOTIFICATION ===");
            log.info("Order ID    : {}", event.getOrderId());
            log.info("Customer    : {} ({})", event.getCustomerName(), event.getCustomerEmail());
            log.info("Total       : {} EUR", event.getTotalAmount());
            log.info("Created at  : {}", event.getCreatedAt());
            log.info("==============================");

            // Delete message from queue after successful processing
            DeleteMessageRequest deleteRequest = DeleteMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .receiptHandle(message.receiptHandle())
                    .build();
            sqsClient.deleteMessage(deleteRequest);

        } catch (Exception e) {
            log.error("Failed to process message {}: {}", message.messageId(), e.getMessage());
            // Message will become visible again after visibility timeout (retry)
        }
    }
}
