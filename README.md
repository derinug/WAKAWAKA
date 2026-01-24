# Order Management API

A RESTful API for managing orders with database persistence, S3 backups, and AWS Step Functions workflow integration.

---

## 📑 Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [API Endpoints](#api-endpoints)
- [Authentication](#authentication)
- [Order Status Values](#order-status-values)
- [Error Handling](#error-handling)
- [Support](#support)
- [License](#license)

---

## Overview

This API provides a complete order management system with the following features:

- Create orders with automatic total price calculation
- List orders with pagination
- Retrieve detailed order information
- Update order status
- Delete orders
- Trigger AWS Step Functions workflows
- Check Step Functions execution status
- Automatic order backup to Amazon S3

---

## Architecture

The system consists of:

- **API Gateway** – REST API entry point  
- **AWS Lambda** – Business logic  
- **Relational Database** – Order persistence  
- **Amazon S3** – Order backup storage  
- **AWS Step Functions** – Order processing workflow  

---

## API Endpoints

### Base URL

```
https://{api-id}.execute-api.{region}.amazonaws.com/{stage}
```

---

### 1. Create Order

**POST** `/orders`

Creates a new order, stores it in the database and S3, and starts a Step Functions workflow.

#### Request

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "x-api-key: YOUR_API_KEY" \
  -d '{
    "customer_id": "CUST001",
    "items": [
      { "product_id": "PROD001", "quantity": 2 },
      { "product_id": "PROD002", "quantity": 1 }
    ]
  }' \
  https://your-api-id.execute-api.region.amazonaws.com/stage/orders
```

#### Response – 201 Created

```json
{
  "message": "Order created successfully",
  "order_id": "550e8400-e29b-41d4-a716-446655440000",
  "execution_arn": "arn:aws:states:us-east-1:123456789012:execution:OrderProcessingStateMachine:example",
  "note": "Save this execution_arn to check workflow status later"
}
```

---

### 2. List Orders

**GET** `/orders`

Retrieves a paginated list of orders.

#### Query Parameters

| Parameter | Type    | Default | Description    |
|---------|---------|---------|----------------|
| page    | Integer | 1       | Page number    |
| limit   | Integer | 10      | Items per page |

#### Request

```bash
curl -X GET \
  -H "x-api-key: YOUR_API_KEY" \
  "https://your-api-id.execute-api.region.amazonaws.com/stage/orders?page=1&limit=10"
```

#### Response – 200 OK

```json
{
  "orders": [
    {
      "order_id": "550e8400-e29b-41d4-a716-446655440000",
      "customer_id": "CUST001",
      "total_amount": 150.75,
      "status": "pending",
      "created_at": "2024-01-24T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 25,
    "pages": 3
  }
}
```

---

### 3. Get Order Details

**GET** `/orders/{order_id}`

Retrieves detailed information about a specific order.

#### Request

```bash
curl -X GET \
  -H "x-api-key: YOUR_API_KEY" \
  https://your-api-id.execute-api.region.amazonaws.com/stage/orders/550e8400-e29b-41d4-a716-446655440000
```

---

## Authentication

All endpoints require API Key authentication.

```
x-api-key: YOUR_API_KEY
```

---

## Order Status Values

| Status     | Description |
|-----------|-------------|
| pending   | Order created, awaiting processing |
| processing| Order is being processed |
| shipped   | Order has been shipped |
| delivered | Order has been delivered |
| cancelled | Order has been cancelled |
| failed    | Order processing failed |

---

## Error Handling

### 400 Bad Request
```json
{ "message": "Missing required field" }
```

### 403 Forbidden
```json
{ "message": "Forbidden" }
```

### 404 Not Found
```json
{ "message": "Order not found" }
```

### 500 Internal Server Error
```json
{
  "message": "Internal server error",
  "error": "Detailed error message"
}
```

---

## Support

For issues or questions:
1. Verify API key usage
2. Check API responses
3. Confirm database and Step Functions configuration

---

## License

This project is licensed under the MIT License.
