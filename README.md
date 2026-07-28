# Azure Automated Employee Onboarding Pipeline

An event-driven **Joiner-Mover-Leaver (JML)** identity automation pipeline built using **Azure Logic Apps** and **Microsoft Entra ID (Azure AD)**. The workflow automates user provisioning by receiving employee information through an HTTP endpoint, creating user accounts in Microsoft Entra ID, and assigning users to department-specific security groups based on business logic.

---

## 📖 Overview

Manual employee onboarding is repetitive, time-consuming, and prone to configuration errors. This project demonstrates how Azure Logic Apps can automate the identity provisioning process using a serverless, low-code workflow.

The application accepts employee details via an HTTP POST request, provisions a new Microsoft Entra ID account, evaluates the employee's department, and automatically assigns the appropriate security group.

---

## 🏗️ Architecture

```
          HTTP POST Request
                 │
                 ▼
    Azure Logic App (HTTP Trigger)
                 │
                 ▼
      Create User (Microsoft Entra ID)
                 │
                 ▼
      Switch Control (Department)
        ┌────────┼────────┐
        ▼        ▼        ▼
       IT       HR      Finance
        │        │         │
        ▼        ▼         ▼
 Add User to  Add User  Add User
 Security     to Group  to Group
   Group
                 │
                 ▼
        HTTP Response (200/400)
```

---

## ⚙️ Features

* Automated Microsoft Entra ID user provisioning
* Event-driven HTTP endpoint
* Department-based routing using Switch control
* Automatic security group assignment
* REST API integration
* JSON schema validation
* HTTP status responses for successful and failed requests

---

## 🛠️ Technology Stack

| Category          | Technology                     |
| ----------------- | ------------------------------ |
| Cloud Platform    | Microsoft Azure                |
| Workflow Engine   | Azure Logic Apps (Consumption) |
| Identity Platform | Microsoft Entra ID (Azure AD)  |
| API Testing       | Postman                        |
| Protocol          | REST                           |
| Request Format    | JSON                           |
| Authentication    | Microsoft Entra ID Connector   |

---

## 📥 Sample Request

```json
{
    "FullName": "Alex Turner",
    "Email": "aturner@adamantojosegmail.onmicrosoft.com",
    "Department": "IT",
    "JobTitle": "Security Analyst"
}
```

---

## 🔄 Workflow

1. Receive an HTTP POST request.
2. Validate the incoming JSON payload.
3. Create a new user in Microsoft Entra ID.
4. Generate a valid `mailNickname`.
5. Evaluate the employee's department.
6. Assign the user to the corresponding security group.
7. Return an HTTP response indicating success or failure.

---

## 📁 JSON Schema

The Logic App expects the following fields:

| Field      | Type   | Required |
| ---------- | ------ | -------- |
| FullName   | String | Yes      |
| Email      | String | Yes      |
| Department | String | Yes      |
| JobTitle   | String | Yes      |

---

## 🔍 Engineering Challenges & Solutions

### 1. Azure Portal Execution Timeout

**Problem**

Testing the workflow using Azure Portal's **Run with Payload** feature occasionally resulted in upstream server timeout errors.

**Solution**

Executed the workflow externally using Postman and the generated Logic App HTTP endpoint, which provided reliable execution and simplified debugging.

---

### 2. Invalid `mailNickname`

**Problem**

Microsoft Entra ID rejected email addresses containing special characters when mapped directly to the `mailNickname` property.

**Error**

```
400 BadRequest
Invalid value specified for property 'mailNickname'
```

**Solution**

Sanitized the value by using only the email prefix (before `@`) to generate a valid alphanumeric `mailNickname`.

Example:

```
Email:
aturner@contoso.com

mailNickname:
aturner
```

---

### 3. Duplicate User Creation

**Problem**

Submitting the same email address multiple times produced an object conflict because Microsoft Entra ID requires every `userPrincipalName` to be unique.

**Error**

```
409 ObjectConflict
Request_BadRequest
```

**Solution**

Modified test payloads with unique email prefixes during validation to prevent identity collisions.

---

## 🚀 How to Run

1. Create an Azure Logic App (Consumption).
2. Add the **When an HTTP request is received** trigger.
3. Define the JSON schema.
4. Add the **Microsoft Entra ID – Create User** action.
5. Authenticate using an account with **User Administrator** or **Global Administrator** privileges.
6. Map the incoming request fields.
7. Generate a valid `mailNickname`.
8. Add a **Switch** control using the **Department** field.
9. Configure group assignment actions for each department.
10. Save the workflow.
11. Copy the generated HTTP endpoint.
12. Send POST requests using Postman.

---

## 📌 Example Departments

| Department | Security Group         |
| ---------- | ---------------------- |
| IT         | IT Security Group      |
| HR         | HR Security Group      |
| Finance    | Finance Security Group |
| Sales      | Sales Security Group   |

---

## 📚 Skills Demonstrated

* Azure Logic Apps
* Microsoft Entra ID
* Identity & Access Management (IAM)
* User Lifecycle Automation
* REST API Integration
* HTTP Triggers
* JSON Schema Validation
* Conditional Workflow Design
* Switch Control Logic
* Security Group Automation
* Troubleshooting Azure Workflows
* Cloud Identity Provisioning

---

## 📜 License

This project is intended for educational and portfolio purposes.


Map dynamic body tokens (FullName, Email, JobTitle) and sanitize mailNickname.

Save, publish, and trigger the workflow endpoint using Postman.

Save, publish, and trigger the workflow endpoint using Postman.
