# Testing Guide for QA Improvements

## Manual Testing Checklist

### 1. Registration Flow Testing

#### Email Validation
- [ ] Test with valid email: `user@gmail.com` → Should accept
- [ ] Test with invalid format: `user@` → Should show "Format email tidak valid"
- [ ] Test with disposable email: `test@guerrillamail.com` → Should show "Email disposable tidak diperbolehkan"
- [ ] Test with empty email → Should show "Email tidak boleh kosong"

#### Password Validation
- [ ] Test with weak password: `password` → Should show validation error
- [ ] Test with no uppercase: `password123!` → Should show "Password harus mengandung huruf besar"
- [ ] Test with no number: `Password!` → Should show "Password harus mengandung angka"
- [ ] Test with valid password: `Password123!` → Should accept

#### NIK Validation
- [ ] Test with valid NIK: `3201012501900001` → Should accept
- [ ] Test with invalid province: `9999012501900001` → Should show "Kode provinsi tidak valid"
- [ ] Test with invalid length: `320101250190` → Should show "NIK harus 16 digit"
- [ ] Test with non-numeric: `320101250190000a` → Should show "NIK hanya boleh berisi angka"

#### Phone Number Validation
- [ ] Test with valid Telkomsel: `081234567890` → Should accept
- [ ] Test with valid XL: `087812345678` → Should accept
- [ ] Test with invalid operator: `080012345678` → Should show "Format nomor telepon tidak valid"
- [ ] Test with too short: `0812345` → Should show "Nomor telepon minimal 10 digit"

#### Address Validation
- [ ] Test with valid address: `Jl. Merdeka No. 123, Jakarta` → Should accept
- [ ] Test with too short: `Jakarta` → Should show "Alamat minimal 10 karakter"
- [ ] Test with empty address → Should show "Alamat tidak boleh kosong"

### 2. Login Flow Testing

#### Email Validation
- [ ] Test login with disposable email → Should show "Email disposable tidak diperbolehkan"
- [ ] Test login with invalid format → Should show "Format email tidak valid"
- [ ] Test login with valid credentials → Should login successfully

#### Error Handling
- [ ] Test with wrong password → Should show "Email atau password salah"
- [ ] Test with unregistered email → Should show "Email tidak terdaftar"
- [ ] Turn off WiFi and try login → Should show "Tidak ada koneksi internet"
- [ ] Turn WiFi back on → Should automatically detect online status

### 3. Profile Update Testing

#### Validation
- [ ] Update NIK with invalid value → Should reject with error message
- [ ] Update phone with invalid format → Should reject with error message
- [ ] Update with valid data → Should update successfully

#### Error Handling
- [ ] Turn off WiFi and try update → Should show offline message
- [ ] Turn WiFi back on and retry → Should succeed with retry mechanism

### 4. Profile Picture Upload Testing

#### Image Validation
- [ ] Upload image >5MB → Should show "Ukuran gambar maksimal 5MB"
- [ ] Upload PDF file → Should show "Format file harus jpg, png, webp, atau heic"
- [ ] Upload valid image → Should compress and upload

#### Image Optimization
- [ ] Upload large image (5MB) → Should be compressed to <1MB
- [ ] Upload high-resolution image (4000x4000) → Should be resized to max 1024x1024
- [ ] Check uploaded image quality → Should maintain good quality (85%)

#### Error Handling
- [ ] Turn off WiFi during upload → Should retry 3 times
- [ ] Turn WiFi back on during retry → Should complete upload
- [ ] Force upload failure (delete bucket) → Should show user-friendly error

### 5. Offline Mode Testing

#### Detection
- [ ] Start app with WiFi ON → Should show "Online" in debug console
- [ ] Turn off WiFi → Should show snackbar "Koneksi terputus"
- [ ] Turn on WiFi → Should show snackbar "Koneksi kembali"

#### Behavior
- [ ] Try to register while offline → Should show offline error immediately
- [ ] Try to login while offline → Should show offline error immediately
- [ ] Try to upload image while offline → Should show offline error immediately

### 6. Retry Mechanism Testing

#### Successful Retry
- [ ] Enable airplane mode
- [ ] Try to login
- [ ] Disable airplane mode within 3 seconds
- [ ] Login should complete successfully (retry worked)

#### Failed Retry
- [ ] Enable airplane mode
- [ ] Try to login
- [ ] Keep airplane mode on for >5 seconds
- [ ] Should show "Tidak ada koneksi internet" after 3 failed attempts

## Automated Testing

### Unit Tests (Create lib/test/validators_test.dart)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hikepassapp/app/utils/validators.dart';

void main() {
  group('NIK Validation', () {
    test('Valid NIK should return null', () {
      expect(Validators.validateNIK('3201012501900001'), null);
      expect(Validators.validateNIK('3273011234567890'), null);
    });

    test('Invalid province code should return error', () {
      expect(Validators.validateNIK('9999012501900001'), isNotNull);
      expect(Validators.validateNIK('0101012501900001'), isNotNull);
    });

    test('Invalid length should return error', () {
      expect(Validators.validateNIK('320101250190'), isNotNull);
      expect(Validators.validateNIK('32010125019000012'), isNotNull);
    });

    test('Non-numeric NIK should return error', () {
      expect(Validators.validateNIK('320101250190000a'), isNotNull);
    });
  });

  group('Phone Number Validation', () {
    test('Valid Telkomsel numbers should return null', () {
      expect(Validators.validatePhoneNumber('081234567890'), null);
      expect(Validators.validatePhoneNumber('082134567890'), null);
    });

    test('Valid XL numbers should return null', () {
      expect(Validators.validatePhoneNumber('087812345678'), null);
      expect(Validators.validatePhoneNumber('087912345678'), null);
    });

    test('Invalid operator should return error', () {
      expect(Validators.validatePhoneNumber('080012345678'), isNotNull);
    });

    test('Invalid length should return error', () {
      expect(Validators.validatePhoneNumber('0812345'), isNotNull);
      expect(Validators.validatePhoneNumber('08123456789012345'), isNotNull);
    });
  });

  group('Email Validation', () {
    test('Valid emails should return null', () {
      expect(Validators.validateEmail('user@gmail.com'), null);
      expect(Validators.validateEmail('test.user@company.co.id'), null);
    });

    test('Disposable emails should return error', () {
      expect(Validators.validateEmail('test@guerrillamail.com'), isNotNull);
      expect(Validators.validateEmail('user@tempmail.com'), isNotNull);
      expect(Validators.validateEmail('spam@10minutemail.com'), isNotNull);
    });

    test('Invalid format should return error', () {
      expect(Validators.validateEmail('invalid'), isNotNull);
      expect(Validators.validateEmail('test@'), isNotNull);
      expect(Validators.validateEmail('@test.com'), isNotNull);
    });
  });

  group('Password Validation', () {
    test('Valid passwords should return null', () {
      expect(Validators.validatePassword('Password123!'), null);
      expect(Validators.validatePassword('MyP@ssw0rd'), null);
    });

    test('Too short password should return error', () {
      expect(Validators.validatePassword('Pass1!'), isNotNull);
    });

    test('No uppercase should return error', () {
      expect(Validators.validatePassword('password123!'), isNotNull);
    });

    test('No lowercase should return error', () {
      expect(Validators.validatePassword('PASSWORD123!'), isNotNull);
    });

    test('No number should return error', () {
      expect(Validators.validatePassword('Password!'), isNotNull);
    });

    test('No special char should return error', () {
      expect(Validators.validatePassword('Password123'), isNotNull);
    });
  });
}
```

### Run Unit Tests
```bash
flutter test test/validators_test.dart
```

## Performance Testing

### Image Optimization
1. Take photo with camera (usually 3-5MB)
2. Observe debug console for "Optimizing image..." message
3. Check uploaded file size in Supabase Storage
4. Expected: <1MB uploaded file

### Network Resilience
1. Enable Chrome DevTools Network Throttling
2. Set to "Slow 3G"
3. Try to register/login
4. Observe retry attempts in debug console
5. Expected: 3 retry attempts before failure

### Memory Profiling
1. Open Flutter DevTools
2. Navigate to Memory tab
3. Test navigation between tabs 10 times
4. Check for memory leaks
5. Expected: No significant memory increase

## Edge Cases Testing

### Boundary Values
- [ ] NIK with minimum valid province (11)
- [ ] NIK with maximum valid province (94)
- [ ] Phone number with minimum length (10 digits)
- [ ] Phone number with maximum length (14 digits)
- [ ] Name with minimum length (2 chars)
- [ ] Name with maximum length (100 chars)
- [ ] Address with minimum length (10 chars)
- [ ] Address with maximum length (500 chars)

### Special Characters
- [ ] Name with numbers: `User123` → Should reject
- [ ] Name with special chars: `User@!` → Should reject
- [ ] Name with valid chars: `User Name` → Should accept
- [ ] Address with special chars: `Jl. No. 123/A` → Should accept

### Race Conditions
- [ ] Double-tap register button → Should only register once
- [ ] Double-tap upload button → Should only upload once
- [ ] Quick navigation during upload → Should not crash

## Production Readiness Checklist

### Before Deployment
- [ ] All manual tests passing
- [ ] All unit tests passing (run `flutter test`)
- [ ] No errors in debug console
- [ ] Tested on Android device
- [ ] Tested on iOS device (if available)
- [ ] Tested on slow network (3G throttling)
- [ ] Tested offline mode
- [ ] Memory profiling shows no leaks
- [ ] Image compression working correctly

### Database
- [ ] Execute indexing SQL (see IMPLEMENTATION_SUMMARY.md)
- [ ] Verify RLS policies enabled
- [ ] Test rate limiting

### Security
- [ ] **CRITICAL**: Regenerate all exposed API keys
- [ ] Update `.env` file with new keys
- [ ] Add `.env` to `.gitignore`
- [ ] Remove hardcoded secrets from code

### Documentation
- [ ] Update README.md with new features
- [ ] Document validation rules
- [ ] Document error handling behavior

---

**Test Coverage Target:** 80%+  
**Manual Test Time:** ~2 hours  
**Automated Test Time:** ~30 minutes (after writing tests)
