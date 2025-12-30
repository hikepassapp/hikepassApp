# 🏔️ HikePass - Modern Hiking Management System

<div align="center">

**A comprehensive mobile application for hiking permit management, real-time tracking, and digital ticketing**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-8B5CF6)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## 📱 About HikePass

HikePass is a modern, full-featured mobile application that digitizes and streamlines the entire hiking permit and management process. Built with Flutter and powered by Supabase, it provides a seamless experience for both hikers (pendaki) and mountain administrators (pengelola).

The app replaces traditional manual systems with a digital platform that handles everything from user registration and permit requests to payment processing, real-time tracking, and emergency reporting.

---

## ✨ Key Features

### 👤 For Hikers (Pendaki)

#### **Authentication & Profile**

- 🔐 Secure email/password registration with OTP verification
- 📧 Email verification system
- 🔑 Password reset via OTP
- 👤 Complete profile management (NIK, phone, address, photo)
- 📸 Avatar upload and management

#### **Hiking Management**

- 📝 Submit hiking permit requests with detailed information
- 🎫 Digital ticket generation and management
- 💳 Integrated payment system (Midtrans)
- 📍 Real-time check-in/check-out system
- 🗺️ Interactive mountain and route information
- 📊 Hiking history and statistics

#### **Information & Communication**

- 📰 Latest news and announcements
- 💬 AI-powered chat assistant (Gemini)
- 🆘 Emergency reporting system
- 📱 Push notifications for updates

### 🏢 For Mountain Administrators (Pengelola)

- ✅ Review and approve/reject hiking permits
- 👥 Manage hiker data and profiles
- 💰 Monitor payments and transactions
- 📊 View reports and analytics
- 🗺️ Manage mountain routes and quotas
- 📢 Publish news and announcements

---

## 🛠️ Tech Stack

### **Frontend**

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: GetX
- **UI Components**: Custom widgets with Material Design
- **Image Handling**: image_picker, image_cropper
- **Maps**: Google Maps Flutter
- **Payments**: Midtrans Flutter SDK

### **Backend & Database**

- **BaaS**: Supabase
- **Database**: PostgreSQL
- **Authentication**: Supabase Auth (Email/Password + OTP)
- **Storage**: Supabase Storage (avatars, documents)
- **Security**: Row Level Security (RLS) policies
- **Real-time**: Supabase Realtime subscriptions

### **Additional Services**

- **AI Chat**: Google Gemini API
- **Payment Gateway**: Midtrans
- **Image Optimization**: flutter_image_compress
- **Local Storage**: shared_preferences
- **HTTP Client**: Supabase client with retry mechanism

---

## 📂 Project Structure

```
lib/
├── app/
│   ├── config/           # Configuration files (Supabase, Gemini, Midtrans)
│   ├── data/            # Data models and entities
│   ├── modules/         # Feature modules (GetX pattern)
│   │   ├── auth/        # Authentication (login, register, OTP)
│   │   ├── profile/     # User profile management
│   │   ├── home/        # Dashboard and home screen
│   │   ├── hiking/      # Hiking permits and check-in/out
│   │   ├── reservasi/   # Reservation management
│   │   ├── riwayat/     # Hiking history
│   │   ├── laporan/     # Emergency reports
│   │   ├── chat/        # AI chat assistant
│   │   ├── berita/      # News and announcements
│   │   └── ...
│   ├── routes/          # App routing configuration
│   ├── services/        # Business logic services
│   │   ├── auth_service.dart
│   │   ├── hiking_service.dart
│   │   ├── reservasi_service.dart
│   │   ├── gemini_service.dart
│   │   └── error_handling_service.dart
│   └── utils/           # Utilities and validators
└── main.dart            # App entry point
```

---

## 🗄️ Database Schema

### **Core Tables**

- **users** - User accounts and basic information
- **pendaki_profiles** - Hiker-specific profile data
- **pengelola_profiles** - Administrator profile data
- **data_gunung** - Mountain information and details
- **hiking** - Hiking permit requests
- **reservasi** - Reservation records
- **payment** - Payment transactions
- **laporan** - Emergency reports
- **berita** - News and announcements
- **riwayat** - Hiking history

---

## 🚀 Getting Started

### **Prerequisites**

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Supabase account
- Midtrans account (for payments)
- Google Cloud account (for Gemini API)

### **Installation**

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/hikepassApp.git
   cd hikepassApp
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure environment variables**

   Create a `.env` file in the root directory:

   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   GEMINI_API_KEY=your_gemini_api_key
   MIDTRANS_CLIENT_KEY=your_midtrans_client_key
   MIDTRANS_SERVER_KEY=your_midtrans_server_key
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔐 Authentication Flow

1. **Registration**

   - User enters email and password
   - System creates account in Supabase
   - OTP sent to email for verification
   - User verifies OTP
   - Complete profile with personal data (NIK, phone, address)

2. **Login**

   - User enters email and password
   - System validates credentials
   - JWT token generated and stored
   - User redirected to home screen

3. **Password Reset**
   - User requests password reset
   - OTP sent to email
   - User verifies OTP
   - User sets new password

---

## 💳 Payment Integration

HikePass uses **Midtrans** for secure payment processing:

1. User submits hiking permit request
2. System generates payment link
3. User completes payment via Midtrans
4. Payment status updated in real-time
5. Ticket generated upon successful payment

---

## 🤖 AI Chat Assistant

Powered by **Google Gemini API**, the chat assistant helps users with:

- Hiking information and tips
- Mountain details and routes
- Weather conditions
- Safety guidelines
- General inquiries

---

## 📊 Key Workflows

### **Hiking Permit Workflow**

```
Submit Request → Admin Review → Approve/Reject → Payment → Ticket Generated → Check-in → Hiking → Check-out
```

### **Emergency Report Workflow**

```
Report Incident → Upload Photos → Submit Location → Admin Notified → Response Dispatched
```

---

## 🔒 Security Features

- ✅ Row Level Security (RLS) policies on all tables
- ✅ JWT-based authentication
- ✅ Secure password hashing (Supabase Auth)
- ✅ OTP verification for sensitive operations
- ✅ Input validation and sanitization
- ✅ Error handling with retry mechanism
- ✅ Secure API key management

---

## 🧪 Testing

Run tests with:

```bash
flutter test
```

---

## 📱 Screenshots

> Add screenshots of your app here

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - _Initial work_ - [YourGitHub](https://github.com/yourusername)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the powerful backend platform
- GetX for state management
- Midtrans for payment integration
- Google for Gemini API

---

## 📞 Support

For support, email support@hikepass.com or open an issue in this repository.

---

<div align="center">

**Made with ❤️ for the hiking community**

⭐ Star this repo if you find it helpful!

</div>
