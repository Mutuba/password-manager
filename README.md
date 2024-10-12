## Backend Rails API Documentation

## Overview

This backend API provides services for managing password vaults and password records securely. It uses AES-256-GCM encryption to securely store vault unlock codes and passwords. This API is designed to work with a frontend client, which interacts with the API endpoints for functionalities such as vault creation, password management, and secure authentication.

## Technologies Used

- Ruby on Rails: Backend framework.
- AES-256-GCM Encryption: For securing vaults and password records.
- Redis: Session management and caching.
- PostgreSQL: Database for storing user, vault, and password records.
- JWT: JSON Web Tokens for secure authentication.

## Endpoints

1. Vault Management

- Create Vault: Creates a new vault.

  - POST /vaults

  - Params:

  ```ruby
    {
        "vault": {
            "name": "Personal Vault",
            "unlock_code": "YourSecurePassword",
            "description": "Description of your vault"
        }
    }
  ```

  - Response

  ```ruby
    {
        "data": {
            "id": 1,
            "name": "Personal Vault",
            "last_accessed_at": null,
            "password_records": []
        }
    }
  ```

2. List Vaults: Lists all vaults for the current user.

   - GET /vaults
   - Response:

   ```ruby
    {
        "data": [
            {
            "id": 1,
            "name": "Personal Vault",
            "last_accessed_at": null,
            "password_records": []
            }
        ]
    }
   ```

3. Login to Vault: Authenticates a user to a specific vault.

   - POST /vaults/login

   - Params:

   ```ruby
   {
       "unlock_code": "YourSecurePassword"
   }

   ```

   - Response

   ```ruby
           {
       "data": {
           "id": 1,
           "name": "Personal Vault",
           "password_records": [
               {
                   "id": 1,
                   "name": "Gmail Account",
                   "username": "user@example.com"
               }
           ]
           }
       }
   ```

4. Password Records Management

- Create Password Record: Creates a new password record for a vault.

- POST /vaults/password_records
- Params:

```ruby
    {
    "password_record": {
        "name": "Gmail Account",
        "username": "user@example.com",
        "password": "YourPassword123",
        "notes": "Personal Gmail account"
    },
    "encryption_key": "Base64EncodedKey"
    }
```

- Response:

```ruby
    {
    "data": {
        "id": 1,
        "name": "Gmail Account",
        "username": "user@example.com",
        "notes": "Personal Gmail account"
    }
    }

```
