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
