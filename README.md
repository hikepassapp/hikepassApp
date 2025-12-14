# HikePass — Modern Hiking Permit & Tracking System

HikePass is a mobile application designed to modernize and streamline the entire hiking permit process. It replaces the traditional manual system with a digital platform that handles registration, ticket management, verification, and real-time tracking for both hikers and mountain management teams.

With HikePass, hikers can easily register, submit hiking requests, purchase tickets, and track the status of their submissions through their mobile device. Meanwhile, administrators can manage hikers, approve or reject permit requests, monitor payments, and control hiking routes and quotas through a unified system.

## 🚀 Features

For Hikers:
    1. Secure login & session handling (Supabase Auth)
    2. Complete hiking permit submission
    3. Digital ticket management
    4. Real-time status updates (pending, approved, paid)
    5. Online payment integration
    6. Hiking history tracking

## 🧩 Tech Stack

Mobile App:
    1. Flutter
    2. GetX (State Management, Routing, Dependency Injection)
    3. Dart

Backend & Database
    1. Supabase
    2. PostgreSQL Database
    3. Authentication (Email & Password)
    4. Session & JWT handling
    5. Row Level Security (RLS)
    6. Supabase Storage (optional for KTP/photo uploads)

Development Tools:
    1. Git & GitHub for version control
    2. Modular development workflow


## 🛠️ System Architecture

HikePass uses a client-driven backend model where the mobile app communicates directly with Supabase through secure RESTful APIs and authentication services.

Supabase handles:
    1. Auth & session management
    2. Data storage and security rules
    3. Access control via RLS

PostgreSQL stores:
    1. User accounts
    2. Hiker & admin details
    3. Hiking tickets
    4. Payments
    5. Route configurations


## 🎯 Purpose

HikePass aims to:

1. Simplify the hiking permit workflow
2. Improve data accuracy and safety
3. Digitize ticketing and approval processes
4. Provide transparency for both hikers and administrators
5. Replace outdated manual systems with a modern, reliable solution

## ⭐ Summary

HikePass is a modern, Flutter–Supabase based hiking management system designed to make the permit, ticketing, and tracking process easier, safer, and more efficient. With real-time data, strong authentication, and a clean user experience, it delivers a reliable digital solution for hiking organizations and outdoor enthusiasts.

