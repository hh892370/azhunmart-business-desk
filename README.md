# AzhunMart Business Desk

An offline-first, single-user ecommerce operations dashboard prototype.

## Current scope
- Orders for Website and WhatsApp, including logistics order ID, AWB, payment type, order status, EDD and delivered date.
- Product variants and editable cost assumptions.
- Daily Meta Ads spend, attributed orders, CAC and ROAS.
- RTO shipping loss and automatic stock return when an order is marked RTO.
- Stock and business expense tracking.
- Dashboard for orders, sales and estimated profit.
- JSON backup and restore.

## Run locally
Open `app/index.html` in a modern browser. Data is stored in that browser profile on that device. Use Backup regularly.

## Important limitations
This prototype is not hosted and has no authentication, cloud database, API integrations, or Gemini connection. It is not suitable for multi-device access or as the sole record of a business. The next production step is to add hosted authentication and a database, then server-side Gemini integration with secrets stored outside the browser.

Do not commit API keys, customer data, or backups to this repository.
