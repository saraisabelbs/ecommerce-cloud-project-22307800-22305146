package pt.ulusofona.notificationservice.event;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderCreatedEvent {
    private Long orderId;
    private String customerName;
    private String customerEmail;
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;
}
