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

5. Update Password Record: Updates an existing password record.

- PUT /vaults/password_records

- Params:

```ruby
    {
        "password_record": {
            "password": "NewPassword123",
            "notes": "Updated account"
        },
        "encryption_key": "Base64EncodedKey"
    }

```

- Response

```ruby
    {
        "data": {
            "id": 1,
            "name": "Gmail Account",
            "username": "user@example.com",
            "notes": "Updated account"
        }
    }

```

6. Decrypt Password: Decrypts a password for a specific record.

- POST /vaults/password_records/decrypt_password

- Params:

```ruby
    {
        "encryption_key": "Base64EncodedKey"
    }

```

- Response

```ruby
    {
        "password": "YourDecryptedPassword"
    }
```

### Getting Started

- Clone the repository.
- Install dependencies: bundle install.
- Set up the database: rails db:setup.
- Start the server: rails server.

### Security

- All encryption is done using AES-256-GCM for both vaults and password records.
- Data is stored securely in the database after encryption.
- Redis is used for session management and timeout control for vault sessions.
- For additional information on API usage, refer to the controllers and models within the application codebase.
