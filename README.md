# E-Invoice & Inventory Manager

A premium, modern invoicing and stock management application built with Flutter. This tool enables small businesses to manage clients, track inventory, and generate professional PDF invoices with ease.

<div align="center">
  <h3>✨ App Demonstration</h3>
</div>

https://raw.githubusercontent.com/IsmailUmmer/icecream_app/main/appsample.mp4

## 🚀 Recent Updates (Inventory Management & UI Overhaul)

This update focuses on transforming the application into a dual-purpose Invoicing and Inventory Management system, with a refined aesthetic and robust data tracking.

### 📦 Advanced Inventory Management
*   **Redesigned Items Tab**: A new, dedicated command center for managing products and services.
*   **Stock Tracking**: Implemented comprehensive fields for inventory management:
    *   **Sale Price** & **Purchase Price** tracking.
    *   **Live Stock Levels**: Automated calculation of **Available Qty** based on **Opening Stock** and **Reserved Qty**.
*   **Quick Links Header**: Instant access to Online Store, Stock Summary, and Item Settings directly from the items repository.
*   **Interactive List**: Tap any item to edit its details or long-press to remove it from the catalog.

### 💳 Invoicing Refinements
*   **Smart Suggestions**: Integrated "Pick from Inventory" and Autocomplete for item names when creating invoices, speeding up the billing process.
*   **Mandatory Validation**: Enforced strict validation for required fields (Client Name, Item Price, etc.) to ensure data integrity.
*   **Multi-Currency Support**: Full support for global currencies, with a focus on **₹ (INR)**. Fixed hardcoded symbols across all transaction screens.

### 📄 PDF & Reporting Excellence
*   **Rupee Symbol Support**: Implemented Google Fonts (Roboto) integration for PDF generation to ensure the **₹** symbol and other special characters render perfectly in high-resolution documents.
*   **Clean Layouts**: Updated the invoice PDF design to remain professional while displaying expanded item details.

### 🎨 UI/UX & Navigation
*   **Unified Design System**: Synchronized the color palette of the new Items section with the app's signature Green and White aesthetic.
*   **Adaptive Navigation**: Restored the classic 5-slot bottom bar with the central (+) FAB, replacing the Profile tab with the high-impact **Items** tab.
*   **Responsive Onboarding**: Fixed layout overflow issues on the "Get Started" screen for seamless performance on all screen sizes.
*   **Smart Shortcuts**: The Home screen profile icon now serves as a direct gateway to your personal account settings.

## 🛠️ Tech Stack
*   **Framework**: Flutter
*   **State Management**: Provider
*   **Persistence**: SharedPreferences / JSON Serialization
*   **PDF Engine**: pdf / printing
*   **Design**: Modern mobile-first UI with smooth micro-animations

## 📈 Get Started
1. Install the APK on your Android device.
2. Complete the onboarding flow.
3. Add your first client and inventory items.
4. Generate and share your first professional invoice in seconds!
