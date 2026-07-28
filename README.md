# Azure Automated Employee Onboarding Pipeline

An automated, event-driven Joiner-Mover-Leaver (JML) identity pipeline built with **Azure Logic Apps** and **Microsoft Entra ID (Azure AD)**. This project receives HTTP POST payloads containing new hire details, programmatically provisions user accounts in Entra ID with sanitized attributes, and dynamically routes users to departmental security groups.

---

## 📌 Architecture Overview

1. **HTTP Trigger:** Receives an HTTP POST request containing structured JSON user data (`FullName`, `Email`, `Department`, `JobTitle`).
2. **Identity Provisioning:** Programmatically creates the user account in **Microsoft Entra ID** with sanitized attributes.
3. **Control Logic:** Evaluates the `Department` parameter using a **Switch** control block.
4. **Group Assignment:** Automatically assigns the user to their respective departmental security group.
5. **Response:** Delivers an HTTP response status code (`200 OK` or `400 Bad Request`).

---

## 🛠️ Tech Stack & Prerequisites

* **Cloud Platform:** Microsoft Azure
* **Services:** Azure Logic Apps (Consumption), Microsoft Entra ID (Azure AD)
* **API Client:** Postman
* **Protocols & Formats:** REST API, HTTP POST, JSON Schema

---

## 📥 Sample Request Payload

```json
{
  "FullName": "Alex Turner",
  "Email": "aturner@adamantojosegmail.onmicrosoft.com",
  "Department": "IT",
  "JobTitle": "Security Analyst"
}

🔍 Engineering & Troubleshooting Log
A key part of developing this pipeline involved diagnosing and resolving several real-world API edge cases:

1. Portal Execution Timeout (Upstream Server Error)
Issue: Testing the HTTP trigger via Azure Portal's built-in Run with Payload feature caused upstream server response timeouts.

Solution: Decoupled execution testing by routing HTTP POST requests directly through Postman using the Logic App workflow URL.

2. Graph API Parameter Validation (mailNickname Rejection)
Issue: Passing raw email strings containing @ symbols or spaces to mailNickname triggered a 400 BadRequest (Invalid value specified for property 'mailNickname').

Solution: Reconfigured the field to strictly accept alphanumeric strings or dynamic string-split prefixes (e.g., aturner).

3. Identity Collision Handling (409 ObjectConflict)
Issue: Re-submitting identical payload emails resulted in an ObjectConflict / Request_BadRequest error due to Entra ID's strict userPrincipalName uniqueness constraint.

Solution: Validated identity constraint handling by dynamically varying email prefixes across test iterations.

🚀 How to Replicate
Create an Azure Logic App (Consumption) in the Azure Portal.

Add the When an HTTP request is received trigger and define the expected JSON schema.

Add the Microsoft Entra ID - Create user action and authenticate with appropriate administrative credentials (User Administrator / Global Administrator).

Map dynamic body tokens (FullName, Email, JobTitle) and sanitize mailNickname.

Save, publish, and trigger the workflow endpoint using Postman.
